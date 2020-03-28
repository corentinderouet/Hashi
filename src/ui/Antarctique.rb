require "gtk3"
require_relative "Carte"
require_relative "Etiquette"

# Widget Gtk affichant l'afrique
class Antarctique < Carte

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
        @dY = -3250
        @factZoom = 1.6

        @g = carte.grillesD

        self.dessinerEtiquettes()
    end

    def dessinerEtiquettes()
        ajouterEtiquette(Etiquette.new(2450, 3250, 90, 30, @carte.etoiles[2][8], @g[8]))
        super()
    end
end
