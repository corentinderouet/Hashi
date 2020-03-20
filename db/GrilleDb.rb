require 'active_record'

require_relative "../src/Grille"
# Classe GrilleDb de la base de données
class GrilleDb < ActiveRecord::Base
	has_many :joueurs, through: :joue
	belongs_to :difficulte
	belongs_to :mode

	serialize :grilleSolution

	def to_s
		"<Grille> difficulte : #{difficultes_id}, mode : #{modes_id}"
	end
end
