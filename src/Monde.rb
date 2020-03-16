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
        @carte.choix("europe")
    end
end
