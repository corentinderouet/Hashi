require 'active_record'
# Classe Difficulte de la base de données
class Difficulte < ActiveRecord::Base
	has_many :grille_dbs

	def to_s
		"<Difficulte> difficulte : '#{niveau}'"
	end
end
