require "gtk3"
require_relative "Affichage"

class Test < Gtk::Window

	def initialize()
		super("Test")
		self.set_default_size(500, 500)


		@aff = Affichage.new(10, 10) 
    
        self.add(@aff)
	end
end

fenetre = Test.new()
fenetre.show_all()
Gtk.main()