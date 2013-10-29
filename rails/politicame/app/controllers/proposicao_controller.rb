class ProposicaoController < ApplicationController
  before_filter :get_proposicao, :only => [:show, :register_vote]
  
  def index
    proposicoes_ids = Votacao.where(:master => 1).pluck(:proposicao_id)
    # where is necessary here due to pagination

    if params[:page].nil? then
      pagen = 1
    else
      pagen = params[:page].to_i
    end

    #.page params[:page]
    @proposicoes_query = Proposicao.where('id IN (?)', proposicoes_ids)
    @proposicoes = @proposicoes_query
    @proposicoes_query = @proposicoes_query.page pagen

    @proposicoes_relevancia_hash = Hash.new
    @proposicoes_relevancia_hash_voted = Hash.new

    @user_signedin = user_signed_in?

    @proposicoes.each do |p|
      positives  = ProposicaoRelevancia.where(:proposicao_id => p.id, :voto => 1).count
      negatives  = ProposicaoRelevancia.where(:proposicao_id => p.id, :voto => 0).count
      @proposicoes_relevancia_hash[p.id] = positives - negatives
      if user_signed_in?
        relevancia = ProposicaoRelevancia.where(:proposicao_id => p.id, :user_id => current_user.id).first
        if !relevancia.nil?
          @proposicoes_relevancia_hash_voted[p.id] = relevancia.voto.to_i
        end
      end
    end

    @proposicoes = @proposicoes.sort{|a,b| @proposicoes_relevancia_hash[b.id] <=> @proposicoes_relevancia_hash[a.id]}
    istart = (pagen - 1)* 9
    @proposicoes = @proposicoes[istart, 9]
  end

  def show
  end

  def register_vote
    #TODO
    #pega usuario
    #busca voto
    #altera ou cria
    #salva
    if !user_signed_in?
      flash[:error] = 'Você precisa fazer login, ou se registrar, para poder votar.'
    else
      voto = VotoUser.where(:user_id => current_user.id, :votacao_id => @votacao.id).first

      if voto.nil?
        voto = VotoUser.new
        voto.user = current_user
      voto.votacao = @votacao
      end

      voto.voto = case params[:vote]
      when Voto::VOTE_YES_STR then Voto::VOTE_YES
      when Voto::VOTE_NO_STR then Voto::VOTE_NO
      when Voto::VOTE_ABSTENTION_STR then Voto::VOTE_ABSTENTION
      when Voto::VOTE_OBSTRUCTION_STR then Voto::VOTE_OBSTRUCTION
      else Voto::VOTE_OTHER
      end

      if voto.save
        flash[:success] = "Voto registrado com sucesso."
      else
        flash[:error] = "Erro ao processar sua opinião sobre #{@proposicao.to_s}. Isso não deveria acontecer :/ . Pedimos que informe-nos sobre esse problema pelo e-mail #{mail_to 'cassio.paixao@gmail.com'}"
      end
    end
    redirect_to :action => 'show', :tipo => @proposicao.tipo, :numero => @proposicao.numero, :ano => @proposicao.ano
  end

  def register_relevance

    if !user_signed_in?
      flash[:error] = 'Você precisa fazer login, ou se registrar, para poder votar.'
    else

      tipo = params[:tipo].strip[0..2].upcase
      numero = params[:numero].to_i
      ano = params[:ano].to_i
      votorel = params[:relevancia].to_i

      proposicao = Proposicao.where(:tipo => tipo, :numero => numero, :ano => ano).first
      voto = ProposicaoRelevancia.where(:user_id => current_user.id, :proposicao_id => proposicao.id).first

      if voto.nil?
        voto = ProposicaoRelevancia.new
        voto.user_id = current_user.id
        voto.proposicao_id = proposicao.id
        voto.voto = votorel
        voto.save
      end
      
    end

    redirect_to :action => 'index'
  end

  private

  def get_proposicao
    tipo = params[:tipo].strip[0..2].upcase
    numero = params[:numero].to_i
    ano = params[:ano].to_i

    @proposicao = Proposicao.where(:tipo => tipo, :numero => numero, :ano => ano).first

    if @proposicao.nil?
      flash[:error] = "Proposta #{tipo} #{numero}/#{ano} não existe."
      redirect_to :action => 'index'
    end

    @votacao = Votacao.where(:proposicao_id => @proposicao.id, :master => '1').first

    if @votacao.nil?
      flash[:error] = "#{@proposicao.to_s} existe, mas não há votação registrada para a mesma."
      redirect_to :action => 'index'
    end
  end

end
