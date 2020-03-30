require "gtk3"
require_relative "SelecteurGrille"

# Widget Gtk permettant d'afficher des sélectionneurs de grille
class AfficheurSelection < Gtk::Box

	# Constructeur
        #
        # === Paramètres
        #
        # * +fenetre+ - Fenetre principale
	def initialize(fenetre)
		super(Gtk::Orientation.new(0), 0)

		boxHorizontale = Gtk::Box.new(Gtk::Orientation.new(0), 0)
		self.add(boxHorizontale)

		stackDif = Gtk::Stack.new()
                stackDif.set_transition_type(Gtk::Stack::TransitionType::SLIDE_UP_DOWN);
                stackDif.set_transition_duration(500);
                boxVerticale = Gtk::Box.new(Gtk::Orientation.new(1), 0)
		sideDif = Gtk::StackSidebar.new()
		sideDif.stack = stackDif
                sideDif.vexpand = true
                boxVerticale.add(sideDif)

                retour = Gtk::Button.new(label: "Retour")
                retour.signal_connect("clicked") { fenetre.finSelection(nil, nil) }
                boxVerticale.add(retour)

		boxHorizontale.add(boxVerticale)
		boxHorizontale.add(stackDif)

		["Facile", "Moyen", "Difficile"].each_with_index() do |dif, i|
			stackDif.add_titled(SelecteurGrille.new(fenetre, i+1), dif, dif)
	        end
	end
end
