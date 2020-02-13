require "gtk3"

require_relative "AfficheurGrille"
require_relative "Case"
require_relative "Lien"
require_relative "Grille"

g= Grille.creer(SerGrille.deserialise(9).tabCase)

fenetre = Gtk::Window.new()
fenetre.set_default_size(500, 500)
fenetre.add(AfficheurGrille.new(g, 7, 10, true))
fenetre.signal_connect('destroy') { Gtk.main_quit }
fenetre.show_all()
Gtk.main()