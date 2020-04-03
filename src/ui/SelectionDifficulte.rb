require "gtk3"

# Widget GTK permettant de choisir une difficulté
class SelectionDifficulte < Gtk::Box

    # Constructeur
    #
    # === Paramètres
    #
    # * +fenetre+ - Fenetre principale
    def initialize(fenetre)
        super(Gtk::Orientation.new(1), 0)

        self.spacing = 5

        l = Gtk::Label.new("")
        l.expand = true
        self.add(l)

        b = Gtk::Button.new(label: "Facile")
        b.signal_connect("clicked") { fenetre.finSelection(GestionBase.recupGrilleAleatoire(fenetre.joueur.id, 1, 2), "classe") }
        self.add(b)
        b = Gtk::Button.new(label: "Moyen")
        b.signal_connect("clicked") { fenetre.finSelection(GestionBase.recupGrilleAleatoire(fenetre.joueur.id, 2, 2), "classe") }
        self.add(b)
        b = Gtk::Button.new(label: "Difficile")
        b.signal_connect("clicked") { fenetre.finSelection(GestionBase.recupGrilleAleatoire(fenetre.joueur.id, 3, 2), "classe") }
        self.add(b)

        l = Gtk::Label.new("")
        l.expand = true
        self.add(l)

        b = Gtk::Button.new(label: "Retour")
        b.signal_connect("clicked") { fenetre.finSelection(nil, nil) }
        self.add(b)
    end
end
