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
require_relative "../src/SerGrille"

class TestBase
	def TestBase.genererBase
		# Réinitialise la base
		Migration.migrate(:up)

		fichiers = ["Facile", "Moyen", "Difficile"]

#		Difficulte.create( :niveau => "Facile")
#		Difficulte.create( :niveau => "Moyen")
#		Difficulte.create( :niveau => "Difficile")
		Mode.create( :mode_jeu => "Entrainement")
		Mode.create( :mode_jeu => "Classe")
		Mode.create( :mode_jeu => "Aventure")
		
		unJoueur = GestionBase.ajouterJoueur("corentin")
		unJoueur2 = GestionBase.ajouterJoueur("alexis")
		
		# Ajoute toutes les grilles de différentes difficultés à la base
		fichiers.each do |difficulte|
			Difficulte.create( :niveau => difficulte )
			SerGrille.transformeSerial2(difficulte)
			tabGrille = SerGrille.deserialiseVide(difficulte)
			idDifficulte = Difficulte.find_by_niveau(difficulte).id
			puts "diff: #{idDifficulte}"
			idMode = 1
puts "nb grilles: #{tabGrille.length}"
#puts tabGrille
			tabGrille.each do |grille|
#puts "idMode: #{idMode}"
#				puts "Grille: #{grille}, tabLien: "
				x = grille.tabLien.length + (idDifficulte / 2.0) - 1
				tempsMoyen = 3.6 * x * x - 34 * x + 120
				tempsMax = 3 * tempsMoyen
				scoreMax = tempsMax + 500 - (3 * (7 - idDifficulte))
#				puts YAML.dump(grille)
				GrilleDb.create(:grilleSolution => YAML.dump(grille), :difficultes_id => idDifficulte, :modes_id => idMode, :scoreMax => scoreMax, :tempsMoyen => tempsMoyen, :tempsMax => tempsMax, :terminee => false)
				idMode = (idMode % 3) + 1
			end

		end
		GestionBase.updateScore
		#grille=GrilleDb.create(:grilleSolution => "1__5HHH", :niveau =>1, :mode_jeu => 3)
		#GrilleDb.create(:grilleSolution => "1__5HHH", :niveau =>2, :mode_jeu => 3)
		#GrilleDb.create(:grilleSolution => "1__5HHH", :niveau =>3, :mode_jeu => 3)
		
		#grille4=GrilleDb.create(:grilleSolution => "1__5HHH", :niveau_id =>3, :mode_jeu => 2)
	end

	def TestBase.test2
#		grille1 = GestionBase.recupGrilles(1).first
		# Joue.create( :joueurs_id => 1, :grille_dbs_id => 1,:grilleSer => nil,  :score => 2521)
#		Joue.create( :joueurs_id => 1, :grille_dbs_id => 4,:grilleSer => grille1,  :score => 3210)
		# Joue.create( :joueurs_id => 1, :grille_dbs_id => 3,:grilleSer => "1__5___;",  :score => 1)
		# Joue.create( :joueurs_id => 1, :grille_dbs_id => 2,:grilleSer => "1__5___;",  :score => 2)
		
		# puts(GestionBase.recupJoueur("corentin"))
		# puts "|#{GestionBase.recupJoueur("robin") == nil}|"
		# puts(GestionBase.recupDifficulte(grille.id))
		# puts(GestionBase.recupMode(grille4.id))
		# puts(GestionBase.recupScoreTotal(1))
		# puts(GestionBase.recupNbGrillesJouees(1))
		# puts "Joueur 4 nb: #{GestionBase.recupNbGrillesJouees(4) == nil}"
		idJoueur = 2
		idDifficulte = 1
		idMode = 1
		GestionBase.recupGrilles(idJoueur, idDifficulte, idMode, 0, 12).each do |grilleDb|
#puts "#{grilleDb}"
#puts "#{grilleDb.grilleSolution}"
			grille = YAML.load(grilleDb.grilleSolution)
#puts "#{grille}"
			grille.clicTriangle(grille.tabCase[0], 1)
			puts "ID: #{grilleDb.id}, Hauteur: #{grille.hauteur}, largeur: #{grille.largeur}, classe: #{grille.class}, scoreMax: #{grilleDb.scoreMax}, tempsMoyen: #{grilleDb.tempsMoyen}"
#			puts "Solution: Hauteur: #{grille.grilleRes.hauteur}, largeur: #{grille.grilleRes.largeur}, classe: #{grille.grilleRes.class}"
#puts "avant grilleDb ser: #{YAML.dump(grille).largeur}"
			grilleDb.grilleSolution = YAML.dump(grille)
#puts "grilleDb ser: #{grilleDb.grilleSolution.largeur}"
			GestionBase.changerScore(idJoueur, grilleDb, 200)

			puts "Score de la grille #{grilleDb.id}: #{GestionBase.recupScore(idJoueur, grilleDb)}"
		end

		puts GestionBase.recupJoueurAll
		
		puts "Score total de joueur 2 difficulté facile: #{GestionBase.recupScoreTotal(idJoueur, 1)}"
		# puts "Grilles: "
		# puts GestionBase.recupGrilles(1)
		# puts "Nil?"
		# puts "|#{GestionBase.recupGrilles(2) == nil}|"
		# puts "|#{GestionBase.recupGrilles(3) == nil}|"
		# puts (GestionBase.changeScore(1, 1, 50))
		# puts(GestionBase.recupScoreTotal(1))
		# puts (GestionBase.changeScore(2, 1, 650))
		#tab=Joue.where([ "joueurs_id = ?", 1 ]).select {|joue| GestionBase.recupMode(GrilleDb.find(joue.grille_dbs_id).id)}# == "Classe"}
		#puts "Tableau"
		#puts tab
		#puts "Somme"
		#score = tab.select{ |joue| GestionBase.recupMode(GrilleDb.find(joue.grille_dbs_id).id).mode_jeu == "Classe"}
		#p score
		#puts score.inject(0) { |score, joue| score += joue.score }
	end

	def TestBase.updateScore
                fichiers = ["Facile", "Moyen", "Difficile"]

		GrilleDb.all.each do |grilleDb|
                        idDifficulte = grilleDb.difficultes_id
			grille = YAML.load(grilleDb.grilleSolution)
#puts tabGrille
#puts "idMode: #{idMode}"
#                               puts "Grille: #{grille}, tabLien: "
       			x = grille.hauteur + (idDifficulte / 2.0) - 1
			tempsMoyen = 3.6 * x * x - 34 * x + 120
			tempsMax = 3 * tempsMoyen
			scoreMax = tempsMax + 500 - (3 * (7 - idDifficulte))
puts "x: #{x}, scoreMax: #{scoreMax}, tempsMoyen: #{tempsMoyen}"
			grilleDb.update(scoreMax: scoreMax, tempsMoyen: tempsMoyen, tempsMax: tempsMax)
		end
	end

	def TestBase.reinitialiser
		Joue.delete_all
	end

end

#TestBase.genererBase
#TestBase.updateScore
TestBase.reinitialiser
