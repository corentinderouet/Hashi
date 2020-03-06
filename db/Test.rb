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

unJoueur = Joueur.create(
:pseudo => "corentin")

