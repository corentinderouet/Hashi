require "gtk3"

require_relative "ui/AfficheurJeu"
require_relative "ui/AfficheurSelection"
require_relative "ui/Connexion"
require_relative "ui/Classement"
require_relative "ui/Aventure"
require_relative "ui/Menu"
require_relative "ui/ChargementAventure"
require_relative "ui/SelectionDifficulte"
require_relative "ui/Didacticiel"
require_relative "SerGrille"
require_relative "../db/GestionBase"

# Fenêtre principale du jeu
class Hashi < Gtk::Window

    # @joueur => Objet joueur en train d'utiliser l'application
    attr_reader :joueur

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
        u = GestionBase.recupJoueur(usr)
        if u
          @joueur = u
          self.remove(@courant)
          puts("Utilisateur connecté: #{usr}")
          self.lancerMenu()
        end
    end

    # Inscription
    #
    # === Paramètres
    #
    # * +usr+ - Utilisateur à créer
    def inscription(usr)
        if (GestionBase.ajouterJoueur(usr)) 
          @joueur = GestionBase.recupJoueur(usr)
          self.remove(@courant)
          puts("Utilisateur créé: #{usr}")
          self.lancerMenu()
        else
          d = Gtk::MessageDialog.new()
          d.text = "Un utilisateur avec ce nom existe déjà"
          d.message_type = :info
          d.run
          d.destroy
        end
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
        if action == "entrainement"
            self.lancerSelection()
        elsif action == "classe"
            self.lancerClasse()
        elsif action == "classement"
            self.lancerClassement()
        elsif action == "aventure"
            self.lancerAventure()
        elsif action == "quitter"
            Gtk.main_quit()
        elsif action == "deconnexion"
            self.lancerConnexion()
        elsif action == "didacticiel"
            @didacticiel = Didacticiel.new()
            self.lancerMenu()
        else
            self.lancerMenu()
        end
    end

    # Lancement du mode classe
    def lancerClasse()
        @courant = SelectionDifficulte.new(self)
        self.refresh()
    end

    # Lancement de l'aventure
    def lancerAventure()
        @courant = ChargementAventure.new(self)
        self.refresh()
        @t = Thread.new() do
            @charge = Aventure.new(self)
            @courant.activer()
        end
    end

    # Fin du chargement de l'aventure
    def finChargement()
        self.remove(@courant)
        @courant = @charge
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
    def lancerJeu(grille, type)
        @courant = AfficheurJeu.new(grille, self, type)
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
    # * +type+ - Mode de jeu
    def finSelection(grille, type)
        self.remove(@courant)
        if grille == nil
            self.lancerMenu()
        else
            self.lancerJeu(grille, type)
        end
    end
end

ActiveRecord::Base.establish_connection(adapter: 'sqlite3', database: '../db/base.sqlite')
Hashi.new()
