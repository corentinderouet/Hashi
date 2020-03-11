require 'active_record'
# Classe Joue de la base de données
class Joue < ActiveRecord::Base
	belongs_to :joueur
	belongs_to :grille_db

	def to_s
		"<Joue> Id du joueur : '#{joueurs_id}', Id de la grille : '#{grille_dbs_id}', score : #{score}"
	end
end
