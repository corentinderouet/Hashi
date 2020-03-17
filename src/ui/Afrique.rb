require "gtk3"
require_relative "Carte"
require_relative "Etiquette"

# Widget Gtk affichant l'afrique
class Afrique < Carte

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
        @dX = -2450
        @dY = -2000
        @factZoom = 1.3
        res=SerGrille.deserialise(8, "m")
        g = Grille.creer(res.tabCase,res.hauteur,res.largeur, nil)
        ajouterEtiquette(Etiquette.new(2150, 1750, 90, 30, 1, g))
        ajouterEtiquette(Etiquette.new(2500, 1780, 90, 30, 2, g))
        ajouterEtiquette(Etiquette.new(2450, 2000, 90, 30, 3, g))
        ajouterEtiquette(Etiquette.new(2730, 2230, 90, 30, 0, g))
        ajouterEtiquette(Etiquette.new(2450, 2330, 90, 30, 3, g))
        ajouterEtiquette(Etiquette.new(2290, 1650, 90, 30, 1, g))
        ajouterEtiquette(Etiquette.new(2420, 2200, 90, 30, 3, g))
        dessinerEtiquettes()
    end
end
