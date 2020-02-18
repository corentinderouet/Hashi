require "gtk3"

require_relative "AfficheurSelection"
require_relative "Case"
require_relative "Lien"
require_relative "Grille"

fenetre = Gtk::Window.new()
fenetre.set_default_size(800, 600)
fenetre.add(AfficheurSelection.new())
fenetre.signal_connect('destroy') { Gtk.main_quit }
fenetre.show_all()
Gtk.main()