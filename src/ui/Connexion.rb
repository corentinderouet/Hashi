require "gtk3"
require_relative "SelectionUtilisateur"

# Widget de connexion
class Connexion < Gtk::Box

    # Constructeur
    #
    # === Paramètres
    #
    # * +fenetre+ - Fenetre principale
    def initialize(fenetre)
        super(Gtk::Orientation.new(1), 0)

        self.margin = 15

        boxHorizontale = Gtk::Box.new(Gtk::Orientation.new(0), 0)
        stack = Gtk::Stack.new()
        switcher = Gtk::StackSwitcher.new()
        switcher.stack = stack
        #.set_size_request(5000, 50)
        lab = Gtk::Label.new("")
        boxHorizontale.add(lab)
        lab.hexpand = true
        boxHorizontale.add(switcher)
        lab = Gtk::Label.new("")
        boxHorizontale.add(lab)
        lab.hexpand = true
        #boxHorizontale.set_homogeneous(true)
        boxHorizontale.set_hexpand(true)

        connexion = Gtk::Box.new(Gtk::Orientation.new(1), 0)
        connexion.add(SelectionUtilisateur.new(fenetre))

        inscription = Gtk::Box.new(Gtk::Orientation.new(1), 0)
        c = Gtk::Label.new("Nom d'utilisateur :")
        c.margin_top = 20
        inscription.add(c)
        e = Gtk::Entry.new()
        e.margin_top = 20
        inscription.add(e)
        c = Gtk::Button.new(label: "Valider")
        c.signal_connect("clicked") { |widget| fenetre.inscription(e.text) }
        c.margin_top = 20
        #stack.hexpand = false
        inscription.add(c)

        stack.add_titled(connexion, "Se connecter", "Se connecter")
        stack.add_titled(inscription, "Creer un compte", "Créer un compte")
        stack.margin_top = 15
        stack.vexpand = true

        bouton = Gtk::Button.new(label: "Quitter")
        bouton.signal_connect("clicked") { |widget| Gtk.main_quit() }

        self.add(boxHorizontale)
        self.add(stack)
        self.add(bouton)
    end
end
