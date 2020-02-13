require "gtk3"

class Jeu < Gtk::Window

	def initialize()
		super("Hashi")
		#provider = Gtk::CssProvider.new()
		#provider.load_from_data(".frame{border:10px solid red;}");
		#Gtk::StyleContext.add_provider_for_screen(Gdk::Screen.default, provider, Gtk::StyleProvider::PRIORITY_APPLICATION)
		self.set_default_size(300, 300)

		#boxHorizontale = Gtk::Box.new(Gtk::Orientation.new(0), 0)
		#boxVerticale.margin = 15

		pan = Gtk::Paned.new(Gtk::Orientation.new(0))
		grille = Gtk::Label.new("Grille")
		grille.hexpand = true

		boxVerticale = Gtk::Box.new(Gtk::Orientation.new(1), 0)
		c = Gtk::Label.new("Timer")
		c.margin_top = 15
		boxVerticale.add(c)
		c = Gtk::Button.new(:label => "Annuler")
		c.margin_top = 15
		boxVerticale.add(c)
		c = Gtk::Button.new(:label => "Refaire")
		boxVerticale.add(c)
		c = Gtk::Button.new(:label => "Vérification")
		boxVerticale.add(c)
		c = Gtk::Button.new(:label => "Hypothèse")
		boxVerticale.add(c)
		box = Gtk::Box.new(Gtk::Orientation.new(1), 0)
		box.margin_top = 15
		box.vexpand = true
		box.add(Gtk::Label.new("Aide :"))
		box.add(Gtk::Button.new(:label => "Position"))
		box.add(Gtk::Button.new(:label => "Technique"))
		#c = Gtk::Label.new("Il y a un 3 dans la grille avec seulement 2 voisins, vous pouvez le relier avec un trait à chacun des deux voisins")
		#c.line_wrap = true;
		#c.margin_top = 20
		#box.add(c)
		boxVerticale.add(box)
		c = Gtk::Button.new(:label => "Pause")
		boxVerticale.add(c)

		pan.add1(grille)
		pan.add2(boxVerticale)
		self.add(pan)
	end
end

fenetre = Jeu.new()
fenetre.show_all()
Gtk.main()