require "gtk3"
require_relative "AfficheurGrille"

# Widget Gtk permettant d'afficher un plateau de jeu
class AfficheurJeu < Gtk::Paned

	# @afficheurGrille => Widget afficheur grille
 	# @timer => Label du timer
 	# @annuler => Bouton annuler
 	# @refaire => Bouton refaire
 	# @hypothese => Bouton hypothèse
 	# @verif => Bouton vérification
	# @aidePos => Bouton aide position
 	# @aideTech => Bouton aide technique
 	# @pause => Bouton pause

	# Constructeur
	#
	# === Parametres
	#
	# * +grille+ => Grille à afficher
	def initialize(grille)
		super(Gtk::Orientation.new(0))

		@grille = grille
		@afficheurGrille = AfficheurGrille.new(grille, 7, 10, true)

		boxVerticale = Gtk::Box.new(Gtk::Orientation.new(1), 0)
		@timer = Gtk::Label.new("Timer")
		@timer.margin_top = 15
        boxVerticale.add(@timer)

		@annuler = Gtk::Button.new(:label => "Annuler")
		@annuler.margin_top = 15
        boxVerticale.add(@annuler)
        @annuler.signal_connect("clicked") { |widget| @grille.annuler() }

		@refaire = Gtk::Button.new(:label => "Refaire")
        boxVerticale.add(@refaire)
        @refaire.signal_connect("clicked") { |widget| @grille.refaire() }

		@verif = Gtk::Button.new(:label => "Vérification")
        boxVerticale.add(@verif)
        @verif.signal_connect("clicked") { |widget| @grille.verification() }

		@hypothese = Gtk::Button.new(:label => "Hypothèse")
        boxVerticale.add(@hypothese)
        @hypothese.signal_connect("clicked") { |widget| @grille.commencerHypothese() }



		box = Gtk::Box.new(Gtk::Orientation.new(1), 0)
		box.margin_top = 15
		box.vexpand = true

        box.add(Gtk::Label.new("Aide :"))

        @aidePos = Gtk::Button.new(:label => "Position")
        box.add(@aidePos)
        @aidePos.signal_connect("clicked") { |widget| @grille.aidePos() }

        @aideTech = Gtk::Button.new(:label => "Technique")
        box.add(@aideTech)
        @aideTech.signal_connect("clicked") { |widget| @grille.aideTech() }

		boxVerticale.add(box)
		@pause = Gtk::Button.new(:label => "Pause")
        boxVerticale.add(@pause)
        @pause.signal_connect("clicked") { |widget| @grille.pause() }

		self.add1(@grille)
		self.add2(boxVerticale)
	end
end