require "gtk3"
require_relative "ListeClassement"

# Widget affichant le classement
class Classement < Gtk::Box

        # Constructeur
        #
        # === Paramètres
        #
        # * +fenetre+ - Fenetre principale
	def initialize(fenetre)
		super(Gtk::Orientation.new(1), 0)

		self.margin = 15


		stack = Gtk::Stack.new()
		switcher = Gtk::StackSwitcher.new()
		switcher.stack = stack
		stack.add_titled(ListeClassement.new(), "Facile", "Facile")
		stack.add_titled(ListeClassement.new(), "Moyen", "Moyen")
		stack.add_titled(ListeClassement.new(), "Difficile", "Difficile")
		stack.margin_top = 15

                bouton = Gtk::Button.new(label: "Retour")
                bouton.signal_connect("clicked") { fenetre.finClassement() }

		self.add(switcher)
		self.add(stack)
                self.add(bouton)
	end
end
