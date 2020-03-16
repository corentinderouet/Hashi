require "gtk3"

require_relative "AfficheurJeu"
require_relative "AfficheurSelection"
require_relative "Connexion"
require_relative "Classement"
require_relative "Aventure"
require_relative "Menu"
require_relative "SerGrille"

# Fenêtre principale du jeu
class Hashi < Gtk::Window

    # Constructeur
    def initialize()
        super("Hashi")
        self.set_default_size(700, 700)
        self.signal_connect('destroy') { Gtk.main_quit }
        
    
        css_provider = Gtk::CssProvider.new()
        css_provider.load_from_path("../assets/FlatColor/gtk-3.20/gtk.css")
        Gtk::StyleContext.add_provider_for_screen(self.screen(), css_provider)
        css_provider = Gtk::CssProvider.new()
        css_provider.load_from_path("../assets/Matcha-dark-aliz/gtk-3.0/gtk.css")
        Gtk::StyleContext.add_provider_for_screen(self.screen(), css_provider)
        @menu = Menu.new(self)

        self.lancerConnexion()

        self.show_all()
        Gtk.main()
    end

    # Mise à jour du widget courant
    def refresh()
        self.add(@courant)
        self.show_all()
    end
    
    # Lancement de la connexion
    def lancerConnexion()
        @courant = Connexion.new(self)
        self.refresh()
    end

    # Connexion
    #
    # === Paramètres
    #
    # * +usr+ - Utilisateur sélectionné
    def connexion(usr)
        self.remove(@courant)
        puts("Utilisateur connecté: #{usr}")
        self.lancerMenu()
    end

    # Inscription
    #
    # === Paramètres
    #
    # * +usr+ - Utilisateur à créer
    def inscription(usr)
        self.remove(@courant)
        puts("Utilisateur créé: #{usr}")
        self.lancerMenu()
    end
    
    # Lancement du classement
    def lancerClassement()
        @courant = Classement.new(self)
        self.refresh()
    end

    # Fin du classement
    def finClassement()
        self.remove(@courant)
        self.lancerMenu()
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
        elsif action == "classement"
            self.lancerClassement()
        elsif action == "aventure"
            self.lancerAventure()
        elsif action == "quitter"
            Gtk.main_quit()
        elsif action == "deconnexion"
            self.lancerConnexion()
        else
            self.lancerMenu()
        end
    end

    # Lancement de l'aventure
    def lancerAventure()
        @courant = Aventure.new(self)
        self.refresh()
    end

    # Fin du jeu
    def finAventure()
        self.remove(@courant)
        self.lancerMenu()
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
