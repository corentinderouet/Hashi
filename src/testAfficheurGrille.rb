require "gtk3"

require_relative "AfficheurGrille"
require_relative "Case"
require_relative "Lien"
require_relative "Grille"

res=SerGrille.deserialise(2,"")
g = Grille.creer(res.tabCase,res.hauteur,res.largeur)
puts(g.largeur, g.hauteur)

fenetre = Gtk::Window.new()
fenetre.set_default_size(500, 500)
fenetre.add(AfficheurGrille.new(g, true))
fenetre.signal_connect('destroy') { Gtk.main_quit }
fenetre.show_all()
Gtk.main()
