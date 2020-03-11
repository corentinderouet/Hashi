#Fonction de gestion de la base de données
require "rubygems"
require "active_record"
require_relative "Joue"
require_relative "Joueur"
require_relative "GrilleDb"
require_relative "Difficulte"
require_relative "Mode"
require_relative "PhrasesAventure"

# Ajoute un joueur à la base de donnée
#
# === Paramètres
#
# * +pseudo+ => Le pseudo que le joueur désire (chaîne de caractères)
#
# === Retour
#
# Vrai si le pseudo est libre, faux si déjà utilisé
#
def ajouterJoueur(pseudo)
	retour = nil

	#Si le pseudo n'est pas déjà pris
	if(recupJoueur(pseudo)==nil)
		retour = Joueur.create( :pseudo => pseudo)
	end

	return retour != nil
end

# Récupère un joueur de la base de donnée via son pseudo
#
# === Paramètres
#
# * +pseudo+ => Le pseudo du joueur que l'on souhaite récupérer (chaîne de caractères)
#
# === Retour
#
# Le joueur si existant, nil sinon
#
def recupJoueur(pseudo)
	return Joueur.find_by_pseudo(pseudo)
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
def recupDifficulte(idGrille)
	grille= GrilleDb.find(idGrille)
	return Difficulte.find_by_niveau(grille.niveau)
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
def recupMode(idGrille)
	grille= GrilleDb.find(idGrille)
	return Mode.find_by_mode_jeu(grille.mode_jeu)
end

# Récupère le score total du joueur sur les grilles qu'il a joué (uniquement en mode classé)
#
# === Paramètres
#
# * +idJoueur+ => L'Id du joueur dont on veut récupérer le score total
#
# === Retour
#
# Le score total du joueur, ou nil si le joueur n'existe pas
#
def recupScoreTotal(idJoueur)
	score = nil

	begin
		Joueur.find(idJoueur)
		grilles = Joue.where([ "joueurs_id = ?", idJoueur ]).select{ |joue| recupMode(GrilleDb.find(joue.grille_dbs_id).id).mode_jeu == "Classe"}
		score = grilles.inject(0) { |score, joue| score += joue.score }

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
def recupNbGrillesJouees(idJoueur)
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

def sauvegarderGrille(idJoueur, grilleDb)
 #==> void (doit avoir la nouvelle grille sérialisée)
end

# Récupère les grilles jouées par le joueur
#
# === Paramètres
#
# * +idJoueur+ => L'Id du joueur dont on veut récupérer les grilles déjà commencées 
#
# === Retour
#
# Les grilles jouées par le joueur, ou nil si le joueur n'existe pas
#
def recupGrilles(idJoueur)
	grilles = nil

	begin
		Joueur.find(idJoueur)
		grilles = Array.new
		joue = Joue.where([ "joueurs_id = ?", idJoueur ])
		begin
			joue.each { |joue| grilles.push(GrilleDb.find(joue.grille_dbs_id)) }
		rescue
			puts "recupGrilles ==> Problème récupération grille depuis joue"
		end
	rescue
		puts "recupGrilles ==> Joueur d'id #{idJoueur} n'existe pas dans la base"
	ensure
		return grilles
	end
end


