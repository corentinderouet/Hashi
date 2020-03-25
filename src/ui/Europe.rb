require "gtk3"
require_relative "Carte"
require_relative "Etiquette"

# Widget Gtk affichant l'europe
class Europe < Carte

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
        @dX = -2350
        @dY = -1300
        @factZoom = 1.5

        g = carte.grillesM

        ajouterEtiquette(Etiquette.new(2250, 1380, 90, 30, 1, g[0]))
        ajouterEtiquette(Etiquette.new(2170, 1320, 90, 30, 2, g[1]))
        ajouterEtiquette(Etiquette.new(2180, 1490, 90, 30, 3, g[2]))
        ajouterEtiquette(Etiquette.new(2340, 1160, 90, 30, 0, g[3]))
        ajouterEtiquette(Etiquette.new(2440, 1340, 90, 30, 3, g[4]))
        ajouterEtiquette(Etiquette.new(2400, 1500, 90, 30, 1, g[5]))
        ajouterEtiquette(Etiquette.new(2620, 1250, 90, 30, 3, g[6]))
        dessinerEtiquettes()
    end

    # Dessin de la carte
    #
    # === Paramètres
    #
    # * +cr+ => Contexte sur lequel dessiner
    def draw(cr)
        super(cr)
    end
end
