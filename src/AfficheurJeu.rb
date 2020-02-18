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

		@hypothese = Gtk::Stack.new()
        @boutonHypothese = Gtk::Button.new(:label => "Hypothèse")
        @boutonHypothese.signal_connect("clicked") { |widget| @grille.commencerHypothese(); @hypothese.visible_child = @boxHypothese; @grille.queue_draw() }
        @hypothese.add_named(@boutonHypothese, "Inactif")

        @boxHypothese = Gtk::Box.new(Gtk::Orientation.new(0), 0)
        @boutonValiderHypothese = Gtk::Button.new(:label => "Valider")
        @boutonValiderHypothese.signal_connect("clicked") { |widget| @grille.validerHypothese(); @hypothese.visible_child = @boutonHypothese; @grille.queue_draw() }
        @boutonValiderHypothese.hexpand = true
        @boutonAnnulerHypothese = Gtk::Button.new(:label => "Annuler")
        @boutonAnnulerHypothese.signal_connect("clicked") { |widget| @grille.annulerHypothese(); @hypothese.visible_child = @boutonHypothese; @grille.queue_draw() }
        @boutonAnnulerHypothese.hexpand = true

        @boxHypothese.add(@boutonAnnulerHypothese)
        @boxHypothese.add(@boutonValiderHypothese)
        @hypothese.add_named(@boxHypothese, "Actif")
        @hypothese.visible_child = @boutonHypothese
        boxVerticale.add(@hypothese)



		box = Gtk::Box.new(Gtk::Orientation.new(1), 0)
		box.margin_top = 15
		box.vexpand = true

        box.add(Gtk::Label.new("Aide :"))

        @aidePos = Gtk::Button.new(:label => "Position")
        @aidePos.margin_top = 5
        box.add(@aidePos)
        @aidePos.signal_connect("clicked") { |widget| @grille.aidePos() }

        @aideTech = Gtk::Button.new(:label => "Technique")
        box.add(@aideTech)
        @aideTech.signal_connect("clicked") { |widget| @grille.aideTech() }

		boxVerticale.add(box)
		@pause = Gtk::Button.new(:label => "Pause")
        boxVerticale.add(@pause)
        @pause.signal_connect("clicked") { |widget| @grille.pause() }

		self.add1(@afficheurGrille)
		self.add2(boxVerticale)
		self.set_position(450)
	end
end