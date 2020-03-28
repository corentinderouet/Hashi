require "gtk3"

# Widget s'affichant pendant le chargement du mode aventure
class ChargementAventure < Gtk::Box

    # Constructeur
    #
    # === Paramètres
    #
    # * +fenetre+ - Fenetre principale
    def initialize(fenetre)
        super(Gtk::Orientation.new(1), 0)

        self.margin = 15

        view = Gtk::TextView.new()
        view.buffer.text = "Histoire et instructions pour le mode aventure à rajouter"
        view.sensitive = false

        scroll = Gtk::ScrolledWindow.new()
        scroll.set_policy(:never, :automatic)
        scroll.expand = true
        scroll.add(view)

        @bouton = Gtk::Button.new(label: "Chargement en cours")
        @bouton.sensitive = false
        @bouton.signal_connect("clicked") { fenetre.finChargement() }
        @bouton.margin_top = 10

        self.add(scroll)
        self.add(@bouton)
    end

    def activer()
        @bouton.label = "Ouvrir la carte du monde"
        @bouton.sensitive = true
    end
end
