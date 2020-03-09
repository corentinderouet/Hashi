require 'active_record'
# Classe Joueur de la base de données
class Joueur < ActiveRecord::Base
	has_many :grilleDbs, through: :joue

	def to_s
		"<Joueur> pseudo : '#{pseudo}'"
	end
end
