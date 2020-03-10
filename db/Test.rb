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

grille=GrilleDb.create(:grilleSer => "1__5___;", :grilleSolution => "1__5HHH", :niveau =>"Facile", :mode_jeu => "Classe")
grille4=GrilleDb.create(:grilleSer => "1__5___;", :grilleSolution => "1__5HHH", :niveau =>"Difficile", :mode_jeu => "Entrainement")

Joue.create( :joueurs_id => 1, :grilleDb_id => 1, :score => 2521)
Joue.create( :joueurs_id => 1, :grilleDb_id => 2, :score => 3210)

puts(recupJoueur("corentin"))
puts(recupDifficulte(grille.id))
puts(recupMode(grille4.id))
puts(recupScoreTotal(1))
puts(recupNbGrillesJouees(1))
puts(recupGrilles(1))