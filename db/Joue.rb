require 'active_record'
# Classe Joue de la base de données
class Joue < ActiveRecord::Base
	belongs_to :joueur
	belongs_to :grilleDb

	def to_s
		"<Joue> Id du joueur : '#{joueurs_id}', Id de la grille : '#{grilleDb_id}'"
	end
end
