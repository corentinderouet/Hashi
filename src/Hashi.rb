require "gtk3"

require_relative "AfficheurJeu"
require_relative "AfficheurSelection"
require_relative "Menu"
require_relative "SerGrille"

# Fenêtre principale du jeu
class Hashi < Gtk::Window

    # Constructeur
    def initialize()
        super("Hashi")
        self.set_default_size(700, 700)
        self.signal_connect('destroy') { Gtk.main_quit }
    
        @menu = Menu.new(self)
        self.lancerMenu()

        self.show_all()
        Gtk.main()
    end

    # Mise à jour du widget courant
    def refresh()
        self.add(@courant)
        self.show_all()
    end

    # Lancement du menu
    def lancerMenu()
        @courant = @menu
        self.refresh()
    end

    # Fin du menu
    #
    # === Paramètres
    #
    # * +action+ - Action sélectionnée dans le menu
    def finMenu(action)
        self.remove(@courant)
        if action == "entrainement" || action == "classe"
            self.lancerSelection()
        elsif action == "deconnexion" || action == "quitter"
            Gtk.main_quit()
        else
            self.lancerMenu()
        end
    end

    # Lancement du jeu
    #
    # === Paramètres
    #
    # * +grille+ - Grille à lancer
    def lancerJeu(grille)
        @courant = AfficheurJeu.new(grille, self)
        self.refresh()
    end

    # Fin du jeu
    def finJeu()
        self.remove(@courant)
        self.lancerMenu()
    end

    # Lancement de la sélection de grille
    def lancerSelection()
        @courant = AfficheurSelection.new(self)
        self.refresh()
    end

    # Fin de la sélection de grille
    #
    # === Paramètres
    #
    # * +grille+ - Grille selectionée
    def finSelection(grille)
        self.remove(@courant)
        if grille == nil
            self.lancerMenu()
        else
            self.lancerJeu(grille)
        end
    end
end

SerGrille.transformeSerial("f")
SerGrille.transformeSerial("m")
SerGrille.transformeSerial("d")
Hashi.new()
