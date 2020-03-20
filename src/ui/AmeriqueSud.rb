require "gtk3"
require_relative "Carte"
require_relative "Etiquette"

# Widget Gtk affichant l'amerique du sud
class AmeriqueSud < Carte

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
        @dX = -1570
        @dY = -2270
        @factZoom = 1.2
        res=SerGrille.deserialise(8, "m")
        g = Grille.creer(res.tabCase,res.hauteur,res.largeur, nil)
        ajouterEtiquette(Etiquette.new(1450, 2000, 90, 30, 1, g))
        ajouterEtiquette(Etiquette.new(1400, 2100, 90, 30, 2, g))
        ajouterEtiquette(Etiquette.new(1650, 2230, 90, 30, 3, g))
        ajouterEtiquette(Etiquette.new(1500, 2380, 90, 30, 0, g))
        ajouterEtiquette(Etiquette.new(1400, 2580, 90, 30, 3, g))
        ajouterEtiquette(Etiquette.new(1450, 2250, 90, 30, 1, g))
        ajouterEtiquette(Etiquette.new(1700, 2100, 90, 30, 3, g))
        dessinerEtiquettes()
    end
end
