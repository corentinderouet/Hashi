require "gtk3"

require_relative "GrilleDb"
require_relative "Case"
require_relative "Lien"
require_relative "Grille"

SerGrille.transformeSerial("m")

res=SerGrille.deserialise(2,"m")
g = Grille.creer(res.tabCase,res.hauteur,res.largeur,res)
puts(g.hauteur, g.largeur)


fenetre = Gtk::Window.new()
fenetre.set_default_size(700, 700)
a = AfficheurJeu.new(g,fenetre)
fenetre.add(a)
fenetre.signal_connect('destroy') { Gtk.main_quit }
fenetre.show_all()
Gtk.main()
