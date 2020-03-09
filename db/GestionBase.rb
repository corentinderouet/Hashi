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
	return Difficulte.find(grille.difficulte_id)
end

def recupMode(idGrille)
	grille= GrilleDb.find(idGrille)
	return Mode.find(grille.mode_id)
end

def recupScoreTotal(idJoueur)
 #==> somme de tous les scores du joueur (int)
end

def recupNbGrillesJouees(idJoueur)
 #==> nombre de grilles jouées par le joueur (int)
end

def sauvegarderGrille(idJoueur, grilleDb)
 #==> void (doit avoir la nouvelle grille sérialisée)
end

def recupGrilles(idJoueur)
 #==> toutes les grilles jouées par le joueur (liste de grilleDb)
end


