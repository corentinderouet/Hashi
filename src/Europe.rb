require "gtk3"
require_relative "Carte"

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
            drawEtiquette(2250, 1380, 90, 30, 1) #France
            drawEtiquette(2170, 1320, 90, 30, 2) #Angleterre
            drawEtiquette(2180, 1490, 90, 30, 3) #Espagne
            drawEtiquette(2340, 1160, 90, 30, 0) #Nord
            drawEtiquette(2440, 1340, 90, 30, 3)
            drawEtiquette(2400, 1500, 90, 30, 1)
            drawEtiquette(2620, 1250, 90, 30, 3)
	end

	# Dessin de la carte
	#
	# === Paramètres
	#
	# * +cr+ => Contexte sur lequel dessiner
    def draw(cr)
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
        @carte.retour()
    end
end
