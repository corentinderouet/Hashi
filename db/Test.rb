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

class TestBase
	def TestBase.test1
		Difficulte.create( :niveau => "Facile")
		Difficulte.create( :niveau => "Moyen")
		Difficulte.create( :niveau => "Difficile")
		Mode.create( :mode_jeu => "Entrainement")
		Mode.create( :mode_jeu => "Classe")
		Mode.create( :mode_jeu => "Aventure")
		
		unJoueur = GestionBase.ajouterJoueur("corentin")
		unJoueur2 = GestionBase.ajouterJoueur("alexis")
		
		grille=GrilleDb.create(:grilleSolution => "1__5HHH", :niveau =>"Facile", :mode_jeu => "Classe")
		GrilleDb.create(:grilleSolution => "1__5HHH", :niveau =>"Moyen", :mode_jeu => "Classe")
		GrilleDb.create(:grilleSolution => "1__5HHH", :niveau =>"Difficile", :mode_jeu => "Classe")
		
		grille4=GrilleDb.create(:grilleSolution => "1__5HHH", :niveau =>"Difficile", :mode_jeu => "Entrainement")
		
		Joue.create( :joueurs_id => 1, :grille_dbs_id => 1,:grilleSer => "1__5___;",  :score => 2521)
		Joue.create( :joueurs_id => 1, :grille_dbs_id => 4,:grilleSer => "1__5___;",  :score => 3210)
		Joue.create( :joueurs_id => 1, :grille_dbs_id => 3,:grilleSer => "1__5___;",  :score => 1)
		Joue.create( :joueurs_id => 1, :grille_dbs_id => 2,:grilleSer => "1__5___;",  :score => 2)
		
		puts(GestionBase.recupJoueur("corentin"))
		puts "|#{GestionBase.recupJoueur("robin") == nil}|"
		puts(GestionBase.recupDifficulte(grille.id))
		puts(GestionBase.recupMode(grille4.id))
		puts(GestionBase.recupScoreTotal(1))
		puts(GestionBase.recupNbGrillesJouees(1))
		puts "Joueur 4 nb: #{GestionBase.recupNbGrillesJouees(4) == nil}"
		puts(GestionBase.recupGrilles(1))
		
		puts GestionBase.recupScoreTotal(1)
		puts "Grilles: "
		puts GestionBase.recupGrilles(1)
		puts "Nil?"
		puts "|#{GestionBase.recupGrilles(2) == nil}|"
		puts "|#{GestionBase.recupGrilles(3) == nil}|"
		puts (GestionBase.changeScore(1, 1, 50))
		puts(GestionBase.recupScoreTotal(1))
		puts (GestionBase.changeScore(2, 1, 650))
		#tab=Joue.where([ "joueurs_id = ?", 1 ]).select {|joue| GestionBase.recupMode(GrilleDb.find(joue.grille_dbs_id).id)}# == "Classe"}
		#puts "Tableau"
		#puts tab
		#puts "Somme"
		#score = tab.select{ |joue| GestionBase.recupMode(GrilleDb.find(joue.grille_dbs_id).id).mode_jeu == "Classe"}
		#p score
		#puts score.inject(0) { |score, joue| score += joue.score }
	end
end

TestBase.test1
