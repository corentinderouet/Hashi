#Fonction de gestion de la base de données
require "rubygems"
require "active_record"
require_relative "Migration"
require_relative "Joue"
require_relative "Joueur"
require_relative "GrilleDb"
require_relative "Difficulte"
require_relative "Mode"
require_relative "PhrasesAventure"

ajouterJoueur(pseudo) ==> void
recupDifficulte(idGrille) ==> difficulté (string)
recupMode(idGrille) ==> mode (string)
recupScoreTotal(idJoueur) ==> somme de tous les scores du joueur (int)
recupNbGrillesJouees(idJoueur) ==> nombre de grilles jourées par le joueur (int)
sauvegarderGrille(idJoueur, grilleDb) ==> void (doit avoir la nouvelle grille sérialisée)
recupGrilles(idJoueur) ==> toutes les grilles jouées par le joueur (liste de grilleDb)


