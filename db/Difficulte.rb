require 'active_record'
# Classe Difficulte de la base de données
class Difficulte < ActiveRecord::Base
	has_many :grilleDbs
end
