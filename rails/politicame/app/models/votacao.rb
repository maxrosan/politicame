class Votacao < ActiveRecord::Base
  attr_accessible :data_hora, :id, :master, :obj_votacao, :resumo
  
  belongs_to :proposicao
  has_many :voto_deputados
end