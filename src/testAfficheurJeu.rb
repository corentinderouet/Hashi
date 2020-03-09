require "gtk3"

require_relative "AfficheurJeu"
require_relative "Case"
require_relative "Lien"
require_relative "Grille"

SerGrille.transformeSerial("m")

res=SerGrille.deserialise(2,"m")
g = Grille.creer(res.tabCase,res.hauteur,res.largeur,res)
puts(g.hauteur, g.largeur)
a = AfficheurJeu.new(g)

fenetre = Gtk::Window.new()
fenetre.set_default_size(700, 700)
fenetre.add(a)
fenetre.signal_connect('destroy') { Gtk.main_quit }
fenetre.show_all()
Gtk.main()
