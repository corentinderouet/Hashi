require "gtk3"
require_relative "Carte"
require_relative "Etiquette"

# Widget Gtk affichant l'oceanie
class Oceanie < Carte

    # @factZoom => Facteur de zoom
    # @dX => Décalage de l'affichage en x
    # @dY => Décalage de l'affichage en y

    private

    # Constructeur
    #
    # === Paramètres
    #
    # * +carte+ - Carte principale
    def initialize(carte)
        super(carte)
        @dX = -3850
        @dY = -2350
        @factZoom = 1.3
        res=SerGrille.deserialise(8, "m")
        g = Grille.creer(res.tabCase,res.hauteur,res.largeur, nil)
        ajouterEtiquette(Etiquette.new(3780, 2065, 90, 30, 1, g))
        ajouterEtiquette(Etiquette.new(4090, 2220, 90, 30, 2, g))
        ajouterEtiquette(Etiquette.new(3850, 2550, 90, 30, 3, g))
        ajouterEtiquette(Etiquette.new(3850, 2400, 90, 30, 0, g))
        ajouterEtiquette(Etiquette.new(3600, 2350, 90, 30, 3, g))
        ajouterEtiquette(Etiquette.new(4140, 2600, 90, 30, 1, g))
        ajouterEtiquette(Etiquette.new(3700, 2222, 90, 30, 3, g))
        dessinerEtiquettes()
    end
end
