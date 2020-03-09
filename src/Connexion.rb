require "gtk3"
require_relative "SelectionUtilisateur"

# Widget de connexion
class Connexion < Gtk::Box

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


		connexion = Gtk::Box.new(Gtk::Orientation.new(1), 0)
		connexion.add(SelectionUtilisateur.new(["Roger", "Gilbert", "Martine", "Alphonse"]))

		inscription = Gtk::Box.new(Gtk::Orientation.new(1), 0)
		c = Gtk::Label.new("Nom d'utilisateur :")
		c.margin_top = 20
		inscription.add(c)
		e = Gtk::Entry.new()
		e.margin_top = 20
		inscription.add(e)
		c = Gtk::Button.new(label: "Valider")
                c.signal_connect("clicked") { |widget| fenetre.inscription(e.text) }
		c.margin_top = 20
		inscription.add(c)

		stack.add_titled(connexion, "Se connecter", "Se connecter")
		stack.add_titled(inscription, "Creer un compte", "Créer un compte")
		stack.margin_top = 15
		self.add(switcher)
		self.add(stack)
	end
end
