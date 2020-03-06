require 'active_record'
# Classe Joueur de la base de données
class Joueur < ActiveRecord::Base
	has_many :grilleDbs, through: :joue
end
