require "gtk3"

# Menu principal
class Menu < Gtk::Box

    # Constructeur
    #
    # === Paramètres
    #
    # * +fenetre+ - Fenetre principale
    def initialize(fenetre)
        super(Gtk::Orientation.new(1), 0)

        self.spacing = 5

        boxHorizontale = Gtk::Box.new(Gtk::Orientation.new(0), 0)
        boxHorizontale.homogeneous = true
        boxHorizontale.margin_top = 10
        c = Gtk::Label.new("")
        c.hexpand = true
        boxHorizontale.add(c)
        b = Gtk::Button.new(label: "Didacticiel")
        b.signal_connect("clicked") { fenetre.finMenu("didacticiel") }
        boxHorizontale.add(b)
        c = Gtk::Label.new("")
        c.hexpand = true
        boxHorizontale.add(c)
        b = Gtk::Button.new(label: "Classement")
        b.signal_connect("clicked") { fenetre.finMenu("classement") }
        boxHorizontale.add(b)
        c = Gtk::Label.new("")
        c.hexpand = true
        boxHorizontale.add(c)
        self.add(boxHorizontale)

        l = Gtk::Label.new("")
        l.expand = true
        self.add(l)

        b = Gtk::Button.new(label: "Entraînement")
        b.signal_connect("clicked") { fenetre.finMenu("entrainement") }
        self.add(b)
        b = Gtk::Button.new(label: "Classé")
        b.signal_connect("clicked") { fenetre.finMenu("classe") }
        self.add(b)
        b = Gtk::Button.new(label: "Aventure")
        b.signal_connect("clicked") { fenetre.finMenu("aventure") }
        self.add(b)

        l = Gtk::Label.new("")
        l.expand = true
        self.add(l)

        boxHorizontale = Gtk::Box.new(Gtk::Orientation.new(0), 0)
        boxHorizontale.homogeneous = true
        boxHorizontale.margin_bottom = 10
        c = Gtk::Label.new("")
        c.hexpand = true
        boxHorizontale.add(c)
        b = Gtk::Button.new(label: "Déconnexion")
        b.signal_connect("clicked") { fenetre.finMenu("deconnexion") }
        boxHorizontale.add(b)
        c = Gtk::Label.new("")
        c.hexpand = true
        boxHorizontale.add(c)
        b = Gtk::Button.new(label: "Quitter")
        b.signal_connect("clicked") { fenetre.finMenu("quitter") }
        boxHorizontale.add(b)
        c = Gtk::Label.new("")
        c.hexpand = true
        boxHorizontale.add(c)
        self.add(boxHorizontale)
    end
end
