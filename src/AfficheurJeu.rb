require "gtk3"

class Jeu < Gtk::widget

	def initialize()
		super("Hashi")
		#provider = Gtk::CssProvider.new()
		#provider.load_from_data(".frame{border:10px solid red;}");
		#Gtk::StyleContext.add_provider_for_screen(Gdk::Screen.default, provider, Gtk::StyleProvider::PRIORITY_APPLICATION)
		self.set_default_size(300, 300)

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

		pan = Gtk::Paned.new(Gtk::Orientation.new(0))
		grille = Gtk::Label.new("Grille")
		grille.hexpand = true

		boxVerticale = Gtk::Box.new(Gtk::Orientation.new(1), 0)
		@timer = Gtk::Label.new("Timer")
		timer.margin_top = 15
        boxVerticale.add(@timer)
        button.signal_connect("clicked") { |widget| timer() }

		@annuler = Gtk::Button.new(:label => "Annuler")
		annuler.margin_top = 15
        boxVerticale.add(@annuler)
        button.signal_connect("clicked") { |widget| annuler() }

		@refaire = Gtk::Button.new(:label => "Refaire")
        boxVerticale.add(@refaire)
        button.signal_connect("clicked") { |widget| refaire() }

		@verif = Gtk::Button.new(:label => "Vérification")
        boxVerticale.add(@verif)
        button.signal_connect("clicked") { |widget| verification() }

		@hypothese = Gtk::Button.new(:label => "Hypothèse")
        boxVerticale.add(@hypothese)
        button.signal_connect("clicked") { |widget| commencerHypothese() }



		box = Gtk::Box.new(Gtk::Orientation.new(1), 0)
		box.margin_top = 15
		box.vexpand = true
        box.add(Gtk::Label.new("Aide :"))
        @aidePos = Gtk::Button.new(:label => "Position")
        box.add(@aidePos)
        button.signal_connect("clicked") { |widget| aidePos() }

        @aideTech = Gtk::Button.new(:label => "Technique")
        box.add(@aideTech)
        button.signal_connect("clicked") { |widget| aideTech() }

		#c = Gtk::Label.new("Il y a un 3 dans la grille avec seulement 2 voisins, vous pouvez le relier avec un trait à chacun des deux voisins")
		#c.line_wrap = true;
		#c.margin_top = 20
		#box.add(c)
		boxVerticale.add(box)
		@pause = Gtk::Button.new(:label => "Pause")
        boxVerticale.add(@pause)
        button.signal_connect("clicked") { |widget| pause() }

		pan.add1(grille)
		pan.add2(boxVerticale)
		self.add(pan)
	end
end

fenetre = Jeu.new()
fenetre.show_all()
Gtk.main()