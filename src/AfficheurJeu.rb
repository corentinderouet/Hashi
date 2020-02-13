require "gtk3"
require_relative "AfficheurGrille"

class AfficheurJeu < Gtk::Paned

	def initialize(grille)
		super(Gtk::Orientation.new(0))
		#provider = Gtk::CssProvider.new()
		#provider.load_from_data(".frame{border:10px solid red;}");
		#Gtk::StyleContext.add_provider_for_screen(Gdk::Screen.default, provider, Gtk::StyleProvider::PRIORITY_APPLICATION)

		#boxHorizontale = Gtk::Box.new(Gtk::Orientation.new(0), 0)
        #boxVerticale.margin = 15
        
     #  @timer
     #   @annuler
     #  @refaire
     #   @hypothese
     #   @verif
     #   @aidePos
     #   @aideTech
     #   @pause

		grille = AfficheurGrille.new(grille, 7, 10, true)
		#grille.hexpand = true

		boxVerticale = Gtk::Box.new(Gtk::Orientation.new(1), 0)
		@timer = Gtk::Label.new("Timer")
		@timer.margin_top = 15
        boxVerticale.add(@timer)

		@annuler = Gtk::Button.new(:label => "Annuler")
		@annuler.margin_top = 15
        boxVerticale.add(@annuler)
        @annuler.signal_connect("clicked") { |widget| annuler() }

		@refaire = Gtk::Button.new(:label => "Refaire")
        boxVerticale.add(@refaire)
        @refaire.signal_connect("clicked") { |widget| refaire() }

		@verif = Gtk::Button.new(:label => "Vérification")
        boxVerticale.add(@verif)
        @verif.signal_connect("clicked") { |widget| verification() }

		@hypothese = Gtk::Button.new(:label => "Hypothèse")
        boxVerticale.add(@hypothese)
        @hypothese.signal_connect("clicked") { |widget| commencerHypothese() }



		box = Gtk::Box.new(Gtk::Orientation.new(1), 0)
		box.margin_top = 15
		box.vexpand = true
        box.add(Gtk::Label.new("Aide :"))
        @aidePos = Gtk::Button.new(:label => "Position")
        box.add(@aidePos)
        @aidePos.signal_connect("clicked") { |widget| aidePos() }

        @aideTech = Gtk::Button.new(:label => "Technique")
        box.add(@aideTech)
        @aideTech.signal_connect("clicked") { |widget| aideTech() }

		#c = Gtk::Label.new("Il y a un 3 dans la grille avec seulement 2 voisins, vous pouvez le relier avec un trait à chacun des deux voisins")
		#c.line_wrap = true;
		#c.margin_top = 20
		#box.add(c)
		boxVerticale.add(box)
		@pause = Gtk::Button.new(:label => "Pause")
        boxVerticale.add(@pause)
        @pause.signal_connect("clicked") { |widget| pause() }

		self.add1(grille)
		self.add2(boxVerticale)
	end
end