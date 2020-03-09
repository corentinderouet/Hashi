#Test de base de données
require "rubygems"
require "active_record"
require_relative "Migration"
require_relative "Joue"
require_relative "Joueur"
require_relative "GrilleDb"
require_relative "Difficulte"
require_relative "Mode"
require_relative "PhrasesAventure"
require_relative "GestionBase"

Difficulte.create( :niveau => "Facile")
Difficulte.create( :niveau => "Moyen")
Difficulte.create( :niveau => "Difficile")
Mode.create( :mode_jeu => "Entrainement")
Mode.create( :mode_jeu => "Classe")
Mode.create( :mode_jeu => "Aventure")

unJoueur = ajouterJoueur("corentin")
unJoueur2 = ajouterJoueur("alexis")

GrilleDb.create(:grilleSer => "VKJZLIJEC", :grilleSolution => "fheijfzei")#, :difficute_id => 1, :mode_id => 1)

#grille2=recupDifficulte(grille.id)
#grille3=recupMode(grille.id)
#puts(grille2)
#puts(grille3)