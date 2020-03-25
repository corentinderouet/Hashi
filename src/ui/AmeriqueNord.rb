require "gtk3"
require_relative "Carte"
require_relative "Etiquette"

# Widget Gtk affichant l'amerique du nord
class AmeriqueNord < Carte

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
        @dX = -1080
        @dY = -1350
        @factZoom = 0.9
        
        g = carte.grillesF
        
        ajouterEtiquette(Etiquette.new(1050, 1790, 90, 30, 1, g[0]))
        ajouterEtiquette(Etiquette.new(1270, 1700, 90, 30, 2, g[1]))
        ajouterEtiquette(Etiquette.new(1000, 1630, 90, 30, 3, g[2]))
        ajouterEtiquette(Etiquette.new(1230, 1530, 90, 30, 0, g[3]))
        ajouterEtiquette(Etiquette.new(930, 1300, 90, 30, 3, g[4]))
        ajouterEtiquette(Etiquette.new(1400, 1250, 90, 30, 1, g[5]))
        ajouterEtiquette(Etiquette.new(500, 1000, 90, 30, 3, g[6]))
        dessinerEtiquettes()
    end
end
