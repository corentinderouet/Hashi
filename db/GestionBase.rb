#Fonction de gestion de la base de données
require "rubygems"
require "active_record"
require_relative "Joue"
require_relative "Joueur"
require_relative "GrilleDb"
require_relative "Difficulte"
require_relative "Mode"
require_relative "PhrasesAventure"

def ajouterJoueur(pseudo)
	retour = nil
	#Si le pseudo n'est pas déjà pris
	if(recupJoueur(pseudo)==nil)
		retour = Joueur.create( :pseudo => pseudo)
	end
	return retour
end

def recupJoueur(pseudo)
	return Joueur.find_by_pseudo(pseudo)
end

def recupDifficulte(idGrille)
	grille= GrilleDb.find(idGrille)
	return Difficulte.find_by_niveau(grille.niveau)
end

def recupMode(idGrille)
	grille= GrilleDb.find(idGrille)
	return Mode.find_by_mode_jeu(grille.mode_jeu)
end

def recupScoreTotal(idJoueur)
	return Joue.where([ "joueurs_id = ?", idJoueur ]).sum(:score)
end

def recupNbGrillesJouees(idJoueur)
	return Joue.where([ "joueurs_id = ?", idJoueur ]).count
end

def sauvegarderGrille(idJoueur, grilleDb)
 #==> void (doit avoir la nouvelle grille sérialisée)
end

def recupGrilles(idJoueur)
	return Joue.where([ "joueurs_id = ?", idJoueur ])
end


