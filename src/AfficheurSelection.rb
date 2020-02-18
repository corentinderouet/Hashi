require "gtk3"
require_relative "SelecteurGrille"

# Widget Gtk permettant d'afficher des sélectionneurs de grille
class AfficheurSelection < Gtk::Box

	# Constructeur
	def initialize()
		super(Gtk::Orientation.new(0), 0)

		boxHorizontale = Gtk::Box.new(Gtk::Orientation.new(0), 0)
		self.add(boxHorizontale)

		stackDif = Gtk::Stack.new()
		sideDif = Gtk::StackSidebar.new()
		sideDif.stack = stackDif

		boxHorizontale.add(sideDif)
		boxHorizontale.add(stackDif)

		["Facile", "Moyen", "Difficile"].each() do |dif|
			stackDif.add_titled(SelecteurGrille.new(), dif, dif)
		end
	end
end