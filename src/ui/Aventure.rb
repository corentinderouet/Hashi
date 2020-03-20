require "gtk3"

require_relative "Monde"
require_relative "Europe"
require_relative "Afrique"
require_relative "Asie"
require_relative "Oceanie"
require_relative "AmeriqueNord"
require_relative "AmeriqueSud"

# Widget Gtk permettant d'afficher l'aventure
class Aventure < Gtk::Stack

    # Constructeur
    #
    # === Paramètres
    #
    # * +fenetre+ - Fenetre principale
    def initialize(fenetre)
        super()
        self.set_transition_type(Gtk::Stack::TransitionType::CROSSFADE);
        self.set_transition_duration(500);

        @fenetre = fenetre
        @monde = Monde.new(self)
        @europe = Europe.new(self)
        @afrique = Afrique.new(self)
        @asie = Asie.new(self)
        @oceanie = Oceanie.new(self)
        @ameriqueNord = AmeriqueNord.new(self)
        @ameriqueSud = AmeriqueSud.new(self)
        self.add_named(@monde, "monde")
        self.add_named(@europe, "europe")
        self.add_named(@afrique, "afrique")
        self.add_named(@asie, "asie")
        self.add_named(@oceanie, "oceanie")
        self.add_named(@ameriqueNord, "ameriqueNord")
        self.add_named(@ameriqueSud, "ameriqueSud")
        @dernier = self.visible_child_name()
        puts(@dernier)
        self.show_all()
    end

    # Fonction appellé par le monde après le chois du continent
    def choix(continent)
        self.set_visible_child_name(continent)
    end

    # Lancement d'une grille
    def lancer(g)
        @dernier = self.visible_child_name()

        self.add_named(AfficheurJeu.new(g, self), "grille")
        self.show_all()
        self.set_visible_child_name("grille")
    end

    # Fin d'une grille
    def finJeu()
        g = self.visible_child()
        self.set_visible_child(@dernier)
        self.remove_child(g)
    end    

    # Fonction appellé les continents pour revenir au monde
    def retour()
        self.set_visible_child(@monde)
    end

    # Retour au menu principal
    def quitter()
        @fenetre.finAventure()
    end
end
