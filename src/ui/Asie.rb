require "gtk3"
require_relative "Carte"
require_relative "Etiquette"

# Widget Gtk affichant l'asie
class Asie < Carte

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
        @dX = -3450
        @dY = -1700
        @factZoom = 1.3

        @g = carte.grillesM

        self.dessinerEtiquettes()
    end

    def dessinerEtiquettes()
        ajouterEtiquette(Etiquette.new(3700, 1600, 90, 30, @carte.etoiles[1][7], @g[7]))
        ajouterEtiquette(Etiquette.new(3200, 1570, 90, 30, @carte.etoiles[1][8], @g[8]))
        ajouterEtiquette(Etiquette.new(3500, 1700, 90, 30, @carte.etoiles[1][9], @g[9]))
        ajouterEtiquette(Etiquette.new(3100, 1800, 90, 30, @carte.etoiles[1][10], @g[10]))
        ajouterEtiquette(Etiquette.new(3340, 1860, 90, 30, @carte.etoiles[1][11], @g[11]))
        ajouterEtiquette(Etiquette.new(3500, 1500, 90, 30, @carte.etoiles[1][12], @g[12]))
        ajouterEtiquette(Etiquette.new(3500, 2000, 90, 30, @carte.etoiles[1][13], @g[13]))
        super()
    end
end
