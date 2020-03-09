require 'active_record'
# Classe Mode de la base de données
class Mode < ActiveRecord::Base
	has_many :grilleDbs
end
