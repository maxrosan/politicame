# Copyright 2013 de PoliticaMe/Cassio Paixao e Max Rosan.
# Este arquivo e parte do programa PoliticaMe. 
# O PoliticaMe e um software livre; voce pode redistribui-lo e/ou modifica-lo 
# dentro dos termos da GNU General Public License.
# como publicada pela Fundacao do Software Livre (FSF); na versao 3 da Licenca. 
# Este programa e distribuido na esperanca que possa ser util, 
# mas SEM NENHUMA GARANTIA; sem uma garantia implicita de ADEQUACAO a qualquer MERCADO ou APLICACAO EM PARTICULAR.
# Veja a licenca para maiores detalhes. 
# Voce deve ter recebido uma copia da GNU General Public License, 
# sob o titulo "LICENCA.txt", junto com este programa, se nao, acesse http://www.gnu.org/licenses/

class Voto < ActiveRecord::Base
  VOTES = [VOTE_YES = 2, VOTE_NO = -2, VOTE_ABSTENTION = -1, VOTE_OBSTRUCTION = 0, VOTE_OTHER = 0]
  VOTES_STR = [VOTE_YES_STR = 'Sim', VOTE_NO_STR = 'Não', VOTE_ABSTENTION_STR = 'Abstenção', VOTE_OBSTRUCTION_STR = 'Obstrução']

end