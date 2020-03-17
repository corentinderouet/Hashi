require "gtk3"

require_relative "Monde"
require_relative "Europe"

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
        self.add_named(@monde, "monde")
        self.add_named(@europe, "europe")
        @dernier = self.visible_child_name()
        puts(@dernier)
        self.show_all()
    end

    # Fonction appellé par le monde après le chois du continent
    def choix(continent)
        if continent == "europe"
            self.set_visible_child_name(continent)
        end
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
