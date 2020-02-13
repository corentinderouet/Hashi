require "gtk3"
require_relative "Grille"
require_relative "AfficheurGrille"
require_relative "Case"
require_relative "Lien"

class SelectionGrille < Gtk::ScrolledWindow

	def initialize()
		super()
		self.set_policy(Gtk::PolicyType::NEVER, Gtk::PolicyType::AUTOMATIC)
		self.expand = true

		grid = Gtk::Grid.new()
		grid.row_spacing = 40
		grid.column_spacing = 40
		grid.margin = 30

		4.times() do |x|
			8.times do |y|
				tab = [Case.creer(0, 0, 1), Case.creer(0, 2, 3), Case.creer(3, 2, 2)]

				tab[0].tabVoisins[1] = tab[1]
				tab[1].tabVoisins[2] = tab[2]
				tab[1].tabVoisins[3] = tab[0]
				tab[2].tabVoisins[0] = tab[1]

				tab[0].tabTriangle[1] = true
				tab[1].tabTriangle[2] = true
				tab[1].tabTriangle[3] = true
				tab[2].tabTriangle[0] = true
				g = Grille.new(tab)

				g.tabLien.push(tab[0].creer_lien(1, false, g.tabLien))
				#g.tabLien.push(tab[1].creer_lien(3, false, g.tabLien))
				g.tabLien.push(tab[1].creer_lien(2, true, g.tabLien))
				#l.expand = true
				grid.attach(AfficheurGrille.new(g, 5, 5, true), x, y, 1, 1)
			end
		end

		self.add(grid)
	end
end
