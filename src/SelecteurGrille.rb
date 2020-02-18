require "gtk3"
require_relative "Grille"
require_relative "AfficheurGrille"
require_relative "Case"
require_relative "Lien"

# Widget Gtk permettant d'afficher un selecteur pour une grille
class SelecteurGrille < Gtk::ScrolledWindow

	# Constructeur
	def initialize()
		super()
		self.set_policy(Gtk::PolicyType::NEVER, Gtk::PolicyType::AUTOMATIC)
		self.expand = true

		grid = Gtk::Grid.new()
		grid.row_spacing = 40
		grid.column_spacing = 40
		grid.margin = 20

		3.times() do |x|
			8.times do |y|
				vBox = Gtk::Box.new(Gtk::Orientation.new(1), 0)
				g = Grille.creer(SerGrille.deserialise(9).tabCase)
				f = Gtk::Frame.new()
				a = AfficheurGrille.new(g, 7, 10, false)
				a.set_size_request(1,300)
				a.expand = true
				f.add(a)
				vBox.add(f)
				vBox.add(Gtk::Label.new("Grille x"))
				vBox.signal_connect("button-press-event") { puts(x, y) }
				grid.attach(vBox, x, y, 1, 1)
			end
		end

		self.add(grid)
	end
end
