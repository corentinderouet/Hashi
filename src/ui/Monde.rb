require "gtk3"
require_relative "Carte"

# Widget Gtk affichant le monde
class Monde < Carte

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
        @dX = -2383
        @dY = -1800
        @factZoom = 0.5

        # Europe
        self.drawRectangleVide(1980, 900, 850, 680, false)
        self.drawTexte(1980 + 850/2, 900 + 680/2, "Europe : 3/24")

        # Afrique
        self.drawRectangleVide(1980, 1600, 850, 900, true)
        self.drawTexte(1980 + 850/2, 1600 + 900/2, "12 pour débloquer")

        # Asie
        self.drawRectangleVide(2850, 750, 1200, 1350, true)
        self.drawTexte(2850 + 1200/2, 750 + 1350/2, "24 pour débloquer")

        # Océanie
        self.drawRectangleVide(3375, 2120, 950, 550, true)
        self.drawTexte(3375 + 950/2, 2120 + 550/2, "24 pour débloquer")

        # Amérique du nord
        self.drawRectangleVide(380, 900, 1300, 950, true)
        self.drawTexte(380 + 1300/2, 900 + 950/2, "24 pour débloquer")

        # Amérique du sud
        self.drawRectangleVide(1150, 1870, 700, 950, true)
        self.drawTexte(1150 + 700/2, 1870 + 950/2, "24 pour débloquer")
    end

    # Dessin de la carte
    #
    # === Paramètres
    #
    # * +cr+ => Contexte sur lequel dessiner
    def draw(cr)
        #ic.rectangle(0, 0, 1000, 1000)
        #ic.fill()
        super(cr)
    end

    # Clic sur la souris
    #
    # === Paramètres
    #
    # * +event+ => Evenement Gtk contenant les informations sur le clic
    def mouseClick(event)
        puts(event.x, event.y)
        puts(getVX(event.x), getVY(event.y))
        x = getVX(event.x)
        y = getVY(event.y)

        # Europe
        if x > 1980 && y >  900 && x < 1980+850 && y < 900+680
            s = "europe"
            # Afrique
        elsif x > 1980 && y > 1600 && x < 1980+850 && y < 1600+900
            s = "afrique"
            # Asie
        elsif x > 2850 && y > 750 && x < 2850+1200 && y < 750+1350
            s = "asie"
            # Océanie
        elsif x > 3375 && y > 2120 && x < 3375+950 && y < 2120+550
            s = "oceanie"
            # Amérique du nord
        elsif x > 380 && y > 900 && x < 380+1300 && y < 900+950
            s = "amerique du nord"
            # Amérique du sud
        elsif x > 1150 && y > 1870 && x < 1150+700 && y < 1870+950
            s = "amerique du sud"
        end
        if s
            puts(s)
            @carte.choix(s)
        else
            @carte.quitter()
        end
    end
end
