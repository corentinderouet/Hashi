require "gtk3"

require_relative "AfficheurSelection"
require_relative "Case"
require_relative "Lien"
require_relative "Grille"

tab = [Case.creer(0, 0, 1), Case.creer(0, 2, 3), Case.creer(3, 2, 2)]

tab[0].tabVoisins[1] = tab[1]
tab[1].tabVoisins[2] = tab[2]
tab[1].tabVoisins[3] = tab[0]
tab[2].tabVoisins[0] = tab[1]

tab[0].tabTriangle[1] = true
tab[1].tabTriangle[2] = true
tab[1].tabTriangle[3] = true
tab[2].tabTriangle[0] = true

g = Grille.creer(tab)

g.tabLien.push(tab[0].creer_lien(1, false, g.tabLien))
#g.tabLien.push(tab[1].creer_lien(3, false, g.tabLien))
g.tabLien.push(tab[1].creer_lien(2, true, g.tabLien))
#g.tabLien.push(tab[0].creer_lien(1, true, g.tabLien))

fenetre = Gtk::Window.new()
fenetre.set_default_size(500, 500)
fenetre.add(AfficheurSelection.new())
fenetre.signal_connect('destroy') { Gtk.main_quit }
fenetre.show_all()
Gtk.main()