require 'active_record'
# Classe GrilleDb de la base de données
class GrilleDb < ActiveRecord::Base
	has_many :joueurs, through: :joue

	def to_s
		"<Grille> difficulte : '#{difficulte_id}', mode : '#{mode_id}'"
	end
end
