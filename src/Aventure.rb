require "gtk3"

# Widget Gtk permettant d'afficher l'aventure
class Aventure < Gtk::DrawingArea

	# Deux systèmes de positions sont utilisés dans le code:
	#
	# => Les positions "virtuelles" (vX, vY) qui correspondent aux coordonnées
	# 	 des cases (par exemple 0,0 pour la case en haut à gauche)
	#
	# => Les positions "réelles" (x, y) qui correspondent aux positions sur
	#    la fenêtre (en pixels) et qui changent en fonction de la résolution de l'écran
	#
	# Les méthodes getX, getY, getVX, getVY sont là pour passer entre ces deux systèmes

	# @vWidth => Largeur virtuelle de la grille
	# @vHeight => Hauteur virtuelle de la grille
	# @ratio => Ratio de la résolution actuelle
	# @vX => Nombre de pixel par coordonnée réelle horizontale
	# @vY => Nombre de pixel par coordonnée réelle verticale

	private

	# Constructeur
	def initialize()
		super()
		@vWidth = 100
		@vHeight = 100
		@ratio = 1.0 * @vWidth / @vHeight
                self.signal_connect("draw") { |widget, cr| draw(cr) }
                self.signal_connect("button-press-event") { |widget, event| mouseClick(event); self.queue_draw() }
                self.events = :all_events_mask
	end

	# Largeur écran en pixels
	#
	# === Retour
	#
	# Retourne le nombre de pixels en largeur affichés à l'écran
	def width()
		return self.allocation.width()
	end

	# Hauteur écran en pixels
	#
	# === Retour
	#
	# Retourne le nombre de pixels en hauteur affichés à l'écran
	def height()
		return self.allocation.height()
	end

	# Conversion vX en x
	#
	# === Paramètres
	#
	# * +vX+ => Position virtuelle en x à convertir
	#
	# === Retour
	#
	# Retourne la position réelle en x correspondante
	def getX(vX)
		if width / @ratio > height
			return vX * @vY + (width - height * @ratio) / 2 + @vY/2
		else
			return vX * @vX + @vX/2
		end
	end

	# Conversion vY en y
	#
	# === Paramètres
	#
	# * +vY+ => Position virtuelle en y à convertir
	#
	# === Retour
	#
	# Retourne la position réelle en y correspondante
	def getY(vY)
		if height * @ratio > width
			return vY * @vX + (height - width / @ratio) / 2 + @vX/2
		else
			return vY * @vY + @vY/2
		end
	end

	# Conversion x en vX
	#
	# === Paramètres
	#
	# * +x+ => Position réelle en x à convertir
	#
	# === Retour
	#
	# Retourne la position virtuelle en x correspondante
	def getVX(x)
		if width / @ratio > height
			return (x - (width - height * @ratio) / 2 - @vY/2) / @vY
		else
			return (x - @vX/2) / @vX
		end
	end

	# Conversion y en vY
	#
	# === Paramètres
	#
	# * +y+ => Position réelle en y à convertir
	#
	# === Retour
	#
	# Retourne la position virtuelle en y correspondante
	def getVY(y)
		if height * @ratio > width
			return (y - (height - width / @ratio) / 2 - @vX/2) / @vX
		else
			return (y - @vY/2) / @vY
		end
	end

	# Retourne une valeur dimensionnée par la taille de l'affichage
	# (utile par exemple pour modifier la taille des cercles
	# en fonction de la taille de la fenêtre)
	#
	# === Paramètres
	#
	# * +s+ => Valeur à dimensionner
	#
	# === Retour
	#
	# Retourne la valeur dimensionnée
	def scale(s)
		if width / @ratio > height
			return s * @vY
		else
			return s * @vX
		end
	end

	# Dessin de la carte
	#
	# === Paramètres
	#
	# * +cr+ => Contexte sur lequel dessiner
    def draw(cr)
    	@vX = 1.0 * width / @vWidth
	@vY = 1.0 * height / @vHeight
        image = Cairo::ImageSurface.from_png("../assets/map.png")
        ic = Cairo::Context.new(image)
	#ic.rectangle(0, 0, 1000, 1000)
	#ic.fill()
        r = 1.0*height/image.height
        r = 1.0*width/image.width if r < 1.0*width/image.width
        cr.scale(r, r)
        cr.set_source(image, 0, 0)
        cr.paint()
    end

    # Clic sur la souris
	#
	# === Paramètres
	#
	# * +event+ => Evenement Gtk contenant les informations sur le clic
    def mouseClick(event)
    	#puts(event.x, event.y)
    	#puts(getVX(event.x), getVY(event.y))
    end
end
