require "gtk3"

require_relative "Aventure"

a = Aventure.new()

fenetre = Gtk::Window.new()
fenetre.set_default_size(700, 700)
fenetre.add(a)
fenetre.signal_connect('destroy') { Gtk.main_quit }
fenetre.show_all()
Gtk.main()
