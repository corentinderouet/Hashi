require "gtk3"
require_relative "ListeClassement"

# Widget affichant le classement
class Classement < Gtk::Box

    # Constructeur
    #
    # === Paramètres
    #
    # * +fenetre+ - Fenetre principale
    def initialize(fenetre)
        super(Gtk::Orientation.new(1), 0)

        self.margin = 15


        stack = Gtk::Stack.new()
        switcher = Gtk::StackSwitcher.new()
        switcher.stack = stack
        stack.add_titled(ListeClassement.new(1), "Facile", "Facile")
        stack.add_titled(ListeClassement.new(2), "Moyen", "Moyen")
        stack.add_titled(ListeClassement.new(3), "Difficile", "Difficile")
        stack.margin_top = 15

        bouton = Gtk::Button.new(label: "Retour")
        bouton.signal_connect("clicked") { fenetre.finClassement() }

        boxHorizontale = Gtk::Box.new(Gtk::Orientation.new(0), 0)
        lab = Gtk::Label.new("")
        boxHorizontale.add(lab)
        lab.hexpand = true
        boxHorizontale.add(switcher)
        lab = Gtk::Label.new("")
        boxHorizontale.add(lab)
        lab.hexpand = true

        self.add(boxHorizontale)
        self.add(stack)
        self.add(bouton)
    end
end
