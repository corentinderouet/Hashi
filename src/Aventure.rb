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

            @monde = Monde.new(self)
            @europe = Europe.new(self)
            self.add_named(@monde, "monde")
            self.add_named(@europe, "europe")
            self.show_all()
        end

        def choix(continent)
            self.set_visible_child(@europe)
        end

        def retour()
            self.set_visible_child(@monde)
        end
end
