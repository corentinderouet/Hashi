require "gtk3"

require_relative "Connexion"

c = Connexion.new()

fenetre = Gtk::Window.new()
fenetre.set_default_size(700, 700)
fenetre.add(c)
fenetre.signal_connect('destroy') { Gtk.main_quit }
fenetre.show_all()
Gtk.main()
