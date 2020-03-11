require 'active_record'
# Classe Mode de la base de données
class Mode < ActiveRecord::Base
	has_many :grille_dbs

	def to_s
		"<Mode> mode : '#{mode_jeu}'"
	end
end
