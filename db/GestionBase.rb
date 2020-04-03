#Fonction de gestion de la base de données
require "rubygems"
require "active_record"
require_relative "Joueur"
require_relative "GrilleDb"
require_relative "Joue"
require_relative "Difficulte"
require_relative "Mode"
require_relative "PhrasesAventure"

# Classe permettant la récupérations d'informations de la Base de données vers le programme grâce au joueur ou aux grilles
class GestionBase
	# Ajoute un joueur à la base de données
	#
	# === Paramètres
	#
	# * +pseudo+ => Le pseudo que le joueur désire (chaîne de caractères)
	#
	# === Retour
	#
	# Vrai si le pseudo est libre, faux si déjà utilisé
	#
	def GestionBase.ajouterJoueur(pseudo)
		retour = nil
	
		#Si le pseudo n'est pas déjà pris
		if(recupJoueur(pseudo)==nil)
			retour = Joueur.create( :pseudo => pseudo)
		end
	
		return retour != nil
	end
	
	# Récupère un joueur de la base de données via son pseudo
	#
	# === Paramètres
	#
	# * +pseudo+ => Le pseudo du joueur que l'on souhaite récupérer (chaîne de caractères)
	#
	# === Retour
	#
	# Le joueur si existant, nil sinon
	#
	def GestionBase.recupJoueur(pseudo)
		return Joueur.find_by_pseudo(pseudo)
	end

	# Récupère tous les joueur de la base de données
	#
	# === Retour
	#
	# Un tableau de joueurs
	#
	def GestionBase.recupJoueurAll
		return Joueur.all
	end
	
	# Récupère la difficulté d'une grille via son Id
	#
	# === Paramètres
	#
	# * +idGrille+ => L'Id de la grille dont on veut récupérer la difficulté
	#
	# === Retour
	#
	# La difficulté (niveau) de la grille (chaîne de caractère), ou nil si impossible à trouver
	#
	def GestionBase.recupDifficulte(idGrille)
		grille= GrilleDb.find(idGrille)
		return Difficulte.find(grille.difficultes_id).niveau
	end
	
	# Récupère le mode de jeu de la grille via son Id
	#
	# === Paramètres
	#
	# * +idGrille+ => L'Id de la grille dont on veut récupérer le mode de jeu
	#
	# === Retour
	#
	# Le mode de jeu de la grille (chaîne de caractère), ou nil si impossible à trouver
	#
	def GestionBase.recupMode(idGrille)
		grille= GrilleDb.find(idGrille)
		return Mode.find(grille.modes_id).mode_jeu
	end

	# Récupère le score du joueur sur la grille
	#
	# === Paramètres
	#
	# * +idJoueur+ => L'Id du joueur dont on veut récupérer le score de la grille
	# * +grilleDb+ => La grille dont on veut récupérer le score
	#
	# === Retour
	#
	# Le score du joueur sur la grilleDb, ou nil si le joueur n'existe pas
	#
	def GestionBase.recupScore(idJoueur, grilleDb)
		score = nil
	
		begin
			Joueur.find(idJoueur)

			begin
				score = Joue.where([ "joueurs_id = ? AND grille_dbs_id = ?", idJoueur, grilleDb.id ]).first.score
			rescue
				score = 0
				puts "recupScore => La grille #{grilleDb.id} n'existe pas pour le joueur #{idJoueur}"
			end
		rescue
			puts "recupScore ==> Joueur d'id #{idJoueur} n'existe pas dans la base"
		ensure
			return score
		end
	end
	
	# Récupère le score total du joueur sur les grilles qu'il a joué (uniquement en mode classé)
	#
	# === Paramètres
	#
	# * +idJoueur+ => L'Id du joueur dont on veut récupérer le score total
	# * +idDifficulte+ => L'Id de la difficulté désirée
	#
	# === Retour
	#
	# Le score total du joueur, ou nil si le joueur n'existe pas
	#
	def GestionBase.recupScoreTotal(idJoueur, idDifficulte)
		score = nil
	
		begin
			Joueur.find(idJoueur)
			grilles = Joue.where([ "joueurs_id = ?", idJoueur ]).select{ |joue| GrilleDb.find(joue.grille_dbs_id).modes_id == Mode.find_by_mode_jeu("Classe").id && GrilleDb.find(joue.grille_dbs_id).difficultes_id == idDifficulte }
			score = grilles.inject(0) { |s, joue| s += joue.score }
		rescue
			puts "recupScoreTotal ==> Joueur d'id #{idJoueur} n'existe pas dans la base"
		ensure
			return score
		end
	#	return Joue.where([ "joueurs_id = ?", idJoueur ]).sum(:score)
	end
	
	# Récupère le nombre de grilles jouées par le joueur (uniquement en mode classé)
	#
	# === Paramètres
	#
	# * +idJoueur+ => L'Id du joueur dont on veut récupérer le nombre de grilles jouées
	#
	# === Retour
	#
	# Le nombre de grilles jouées par le joueur, ou nil si le joueur n'existe pas
	#
	def GestionBase.recupNbGrillesJouees(idJoueur)
		nb = nil
	
		begin
			Joueur.find(idJoueur)
			grilles = Joue.where([ "joueurs_id = ?", idJoueur ]).select{ |joue| recupMode(GrilleDb.find(joue.grille_dbs_id).id).mode_jeu == "Classe"}
			nb = grilles.inject(0) { |nb, joue| nb += 1 }
		rescue
			puts "recupNbGrillesJouees ==> Joueur d'id #{idJoueur} n'existe pas dans la base"
		ensure
			return nb
		end
	#	return Joue.where([ "joueurs_id = ?", idJoueur ]).count
	end
	
	# Sauvegarde la grilles jouée par le joueur ou la créée si elle n'existe pas
	#
	# === Paramètres
	#
	# * +idJoueur+ => L'Id du joueur dont on veut récupérer la grille déjà commencées
	# * +grilleDb+ => L'objet grille à enregistrer
	#
	# === Retour
	#
	# Aucun retour (Enregistrement dans la base)
	#
	def GestionBase.sauvegarderGrille(idJoueur, grilleDb)
		begin			
			raise ("raise sauvegarderGrille") if ((joue=Joue.where([ "joueurs_id = ? AND grille_dbs_id = ?", idJoueur, grilleDb.id ])).count != 1)
			
		rescue
			Joue.create( :joueurs_id => idJoueur, :grille_dbs_id => grilleDb.id)
		end
	end
	
	# Récupère les grilles jouées par le joueur
	#
	# === Paramètres
	#
	# * +idJoueur+ => L'Id du joueur dont on veut récupérer les grilles déjà commencées 
	# * +idDifficulte+ => L'Id de la difficulté des grilles qu'on souhaite récupérer
	# * +idMode+ => L'Id du mode des grilles qu'on souhaite récupérer
	# * +nbDebut+ => Le rang auquel commencer la récupération des grilles (début à 0, fin à 89)
	# * +nbGrilles+ => Le nombre de grilles à récupérer à partir de nbDebut
	#
	# === Retour
	#
	# Les grilles, d'un nombre et de la difficulté voulus, jouées par le joueur, ou nil si le joueur n'existe pas
	#
	def GestionBase.recupGrilles(idJoueur, idDifficulte, idMode, nbDebut, nbGrilles)
		grilles = nil
	
		begin
			Joueur.find(idJoueur)
			grilles = Array.new #GrilleDb.all
#			joue = Joue.where([ "joueurs_id = ?", idJoueur ])
			begin
				GrilleDb.where(difficultes_id: idDifficulte, modes_id: idMode).offset(nbDebut).limit(nbGrilles).each do |grilleDb|
#puts grille.id
#joue = nil
					begin
						joue = Joue.where([ "joueurs_id = ? AND grille_dbs_id = ?", idJoueur, grilleDb.id ]).first
					rescue
						joue = nil
					end
#joue.each { |j| puts "Joue: #{j}" }
					if (joue != nil)
#p joue
						grilleDb.grilleSolution = joue.grilleSer
					else
#						grille = grilleDb.grilleSolution
#						grilleDb.grilleSolution = YAML.load(grilleDb.grilleSolution)
						grille = grilleDb.grilleSolution
#puts "Joue:  #{joue == nil}"
#p grille
						grille2 = YAML.load(grille)
#puts "Grille2: "
#puts grille2
						grille = Grille.creer(grille2.tabCase, grille2.hauteur, grille2.largeur, grille2)
#puts "Grille: "
#puts grille
#						grille.tabLien.each { |lien| grille.supprimerLien(lien) }
						grilleDb.grilleSolution = YAML.dump(grille)
#:niveau => difficulte
						Joue.create( :joueurs_id => idJoueur, :grille_dbs_id => grilleDb.id, :grilleSer => grilleDb.grilleSolution, :score => 0, :terminee => false )
					end

					grilles.push(grilleDb)
				end
#				joue.map { |joue| grilles.push(GrilleDb.find(joue.grille_dbs_id)) }
			rescue
				puts "recupGrilles ==> Problème récupération grille depuis joue"
			end
		rescue
			puts "recupGrilles ==> Joueur d'id #{idJoueur} n'existe pas dans la base"
		ensure
			return grilles
		end
	end


	# Modifie le score de la grille d'un Joueur
	#
	# === Paramètres
	#
	# * +idJoueur+ => L'Id du Joueur dont on veut modifier le scre de l'une des grilles
	# * +grilleDb+ => L'objet grille dont on veut modifier le score
	# score à supprimer des paramètres
	# === Retour
	#
	# Aucun : modifie le score de la grille du joueur ainsi que la grilleSer
	#
	def GestionBase.changerScore(idJoueur, grilleDb, score)
		begin
			raise ("raise changerScore") if ((joue=Joue.where([ "joueurs_id = ? AND grille_dbs_id = ?", idJoueur, grilleDb.id ])).count != 1)
			joue = joue.first
			idDifficulte = grilleDb.difficultes_id
			grille = YAML.load(grilleDb.grilleSolution)
#			puts "grille: #{grille.nbAides}"

			tempsReel = grille.timer
			nbAides = 10 * grille.nbAides
			terminee = false
			begin
				raise ("Grille non terminée") if (!grille.grilleFinie)
				score = grilleDb.tempsMax + (3 * (grilleDb.tempsMoyen - tempsReel)) - nbAides + 500 - (3 * (7 - idDifficulte))
				terminee = true
				puts "score: #{score}, scoreMax: #{grilleDb.scoreMax}, tempsMoyen: #{grilleDb.tempsMoyen}"
			rescue # timer == 0?
#				puts "Timer: #{tempsReel}"
				score = 0
			end
#			score = grilleDb.scoreMax * grilleDb.tempsMoyen
			joue.update(score: score, grilleSer: grilleDb.grilleSolution, terminee: terminee)# if (joue.score < score)
		rescue
			puts "changeScore ==> La grille d'id #{grilleDb.id} du joueur d'id #{idJoueur} n'existe pas dans la base. Score: #{score}"
		end
	end

	# Permet de savoir si une grille a été terminée par le joueur
	#
	# === Paramètres
	#
	# * +idJoueur+ => L'Id du Joueur dont on veut savoir s'il a terminé la grille
	# * +grilleDb+ => L'objet grille dont on veut savoir si elle a été terminée
	#
	# === Retour
	#
	# Si le joueur et la grille existent, renvoie l'état de la grille (true ou false), nil si la grille n'existe pas pour le joueur
	#
	def GestionBase.grilleTerminee?(idJoueur, grilleDb)
		terminee = nil
		begin
			raise ("raise grilleTerminee?") if ((joue=Joue.where([ "joueurs_id = ? AND grille_dbs_id = ?", idJoueur, grilleDb.id ])).count != 1)
			terminee = joue.first.terminee
		rescue
			puts "grilleTerminee? ==> La grille d'id #{grilleDb.id} du joueur d'id #{idJoueur} n'existe pas dans la base."
		ensure
			return terminee
		end
	end
end
