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
GrilleDb.create(:grilleSer => "1__5___;", :grilleSolution => "1__5HHH", :niveau =>"Moyen", :mode_jeu => "Classe")
GrilleDb.create(:grilleSer => "1__5___;", :grilleSolution => "1__5HHH", :niveau =>"Difficile", :mode_jeu => "Classe")

grille4=GrilleDb.create(:grilleSer => "1__5___;", :grilleSolution => "1__5HHH", :niveau =>"Difficile", :mode_jeu => "Entrainement")

Joue.create( :joueurs_id => 1, :grille_dbs_id => 1, :score => 2521)
Joue.create( :joueurs_id => 1, :grille_dbs_id => 4, :score => 3210)
Joue.create( :joueurs_id => 1, :grille_dbs_id => 3, :score => 1)
Joue.create( :joueurs_id => 1, :grille_dbs_id => 2, :score => 2)

puts(recupJoueur("corentin"))
puts "|#{recupJoueur("robin") == nil}|"
puts(recupDifficulte(grille.id))
puts(recupMode(grille4.id))
puts(recupScoreTotal(1))
puts(recupNbGrillesJouees(1))
puts "Joueur 4 nb: #{recupNbGrillesJouees(4) == nil}"
puts(recupGrilles(1))

puts recupScoreTotal(1)
puts "Grilles: "
puts recupGrilles(1)
puts "Nil?"
puts "|#{recupGrilles(2) == nil}|"
puts "|#{recupGrilles(3) == nil}|"
#tab=Joue.where([ "joueurs_id = ?", 1 ]).select {|joue| recupMode(GrilleDb.find(joue.grille_dbs_id).id)}# == "Classe"}
#puts "Tableau"
#puts tab
#puts "Somme"
#score = tab.select{ |joue| recupMode(GrilleDb.find(joue.grille_dbs_id).id).mode_jeu == "Classe"}
#p score
#puts score.inject(0) { |score, joue| score += joue.score }
