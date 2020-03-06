# Classe Joueur de la base de données
class Joueur < ActireRecord::Base
	has_many :grilleDbs, through => joue
end
