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

        @g = carte.grillesD

        self.dessinerEtiquettes()
    end

    def dessinerEtiquettes()
        ajouterEtiquette(Etiquette.new(2150, 1750, 90, 30, @carte.etoiles[2][7], @g[7]))
        ajouterEtiquette(Etiquette.new(2500, 1780, 90, 30, @carte.etoiles[2][8], @g[8]))
        ajouterEtiquette(Etiquette.new(2450, 2000, 90, 30, @carte.etoiles[2][9], @g[9]))
        ajouterEtiquette(Etiquette.new(2730, 2230, 90, 30, @carte.etoiles[2][10], @g[10]))
        ajouterEtiquette(Etiquette.new(2450, 2330, 90, 30, @carte.etoiles[2][11], @g[11]))
        ajouterEtiquette(Etiquette.new(2290, 1650, 90, 30, @carte.etoiles[2][12], @g[12]))
        ajouterEtiquette(Etiquette.new(2420, 2200, 90, 30, @carte.etoiles[2][13], @g[13]))
        super()
    end
end
