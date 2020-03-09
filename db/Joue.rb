require 'active_record'
# Classe Joue de la base de données
class Joue < ActiveRecord::Base
	belongs_to :joueur
	belongs_to :grilleDb

end
