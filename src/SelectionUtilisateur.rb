class SelectionUtilisateur < Gtk::ScrolledWindow

	def initialize(utilisateurs)
		super()
		self.set_policy(Gtk::PolicyType::NEVER, Gtk::PolicyType::AUTOMATIC)
		self.expand = true
        boxHorizontale = Gtk::Box.new(Gtk::Orientation.new(0), 0)
		grid = Gtk::Grid.new()
        grid.row_spacing = 20
        grid.column_spacing = 20
        grid.margin = 5
        lab = Gtk::Label.new("")
        lab.hexpand = true
        boxHorizontale.add(lab)
        boxHorizontale.add(grid)
        lab = Gtk::Label.new("")
        lab.hexpand = true
        boxHorizontale.add(lab)
        #boxHorizontale.set_homogeneous(true)
		


                x = 0
                y = 0

                utilisateurs.each() do |u|
                    l = Gtk::Button.new(label: u)
                    #l.expand = true
                    l.signal_connect("clicked") { |widget| puts("Connexion de #{u}") }
                    l.set_size_request(150, 70)
                    grid.attach(l, x, y, 1, 1)
                    x += 1
                    if x > 2
                        y += 1
                        x = 0
                    end
                end

		self.add(boxHorizontale)
	end
end
