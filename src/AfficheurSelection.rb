require "gtk3"
require_relative "SelectionGrille"

class AfficheurSelection < Gtk::Box

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
			stackDif.add_titled(SelectionGrille.new(), dif, dif)
		end
	end
end