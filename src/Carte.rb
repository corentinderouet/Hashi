require "gtk3"

# Widget Gtk ABSTRAIT permettant d'afficher la carte
class Carte < Gtk::DrawingArea

	# Deux systèmes de positions sont utilisés dans le code:
	#
	# => Les positions "virtuelles" (vX, vY) qui correspondent aux coordonnées
	#    sur l'image
	#
	# => Les positions "réelles" (x, y) qui correspondent aux positions sur
	#    la fenêtre (en pixels) et qui changent en fonction de la résolution de l'écran
	#
	# Les méthodes getX, getY, getVX, getVY sont là pour passer entre ces deux systèmes

	# @image => Carte du monde
        # @ic => Contexte de dessin de la carte du monde
	# @zoom => Zoom une fois affichée
        # @factZoom => Facteur de zoom
	# @dX => Décalage de l'affichage en x
	# @dY => Décalage de l'affichage en y

	private

	# Constructeur
        #
        # === Paramètres
        #
        # * +carte+ - carte principale
	def initialize(carte)
		super()
                @carte = carte
                self.signal_connect("draw") { |widget, cr| draw(cr) }
                self.signal_connect("button-press-event") { |widget, event| mouseClick(event); self.queue_draw(); }
                self.events = :all_events_mask
                @image = Cairo::ImageSurface.from_png("../assets/map.png")
                @ic = Cairo::Context.new(@image)
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
            return -@dX+(x-width/2)/@zoom
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
            #return y-@dY-height/2
            return -@dY+(y-height/2)/@zoom
	end

	# Dessin de la carte
	#
	# === Paramètres
	#
	# * +cr+ => Contexte sur lequel dessiner
    def draw(cr)
	#ic.rectangle(0, 0, 1000, 1000)
	#ic.fill()
        @zoom = @factZoom * width / height / 2
        cr.scale(@zoom, @zoom)
        cr.set_source(@image, (@dX + width/2/@zoom), (@dY + height/2/@zoom))
        cr.paint()
    end
    
    # Dessin d'un rectangle
    #
    # === Paramètres
    #
    # * +x+ - Position en x du rectangle
    # * +y+ - Position en y du rectangle
    # * +w+ - Largeur du rectangle
    # * +h+ - Hauteur du rectangle
    # * +a+ - Courbure des bords du rectangle
    def drawRectangle(x, y, w, h, a)
        radius = h / 10.0  / a
        degrees = Math::PI / 180.0;

        @ic.new_sub_path()
        @ic.arc(x + w - radius, y + radius, radius, -90 * degrees, 0 * degrees)
        @ic.arc(x + w - radius, y + h - radius, radius, 0 * degrees, 90 * degrees)
        @ic.arc(x + radius, y + h - radius, radius, 90 * degrees, 180 * degrees)
        @ic.arc(x + radius, y + radius, radius, 180 * degrees, 270 * degrees)
        @ic.close_path()

        @ic.set_source_rgb(1, 1, 1)
        @ic.fill_preserve()
        @ic.set_source_rgb(0, 0, 0)
        @ic.set_line_width(2.0)
        @ic.stroke()
    end

    # Dessin d'une étoile
    #
    # === Paramètres
    #
    # * +x+ - Position en x de l'étoile
    # * +y+ - Position en y de l'étoile
    # * +s+ - Taille de l'étoile
    # * +c+ - Couleur de l'étoile
    def drawEtoile(x, y, s, c)
        @ic.new_sub_path()
        @ic.move_to(x + s/2, y-2)
        @ic.line_to(x + s/5, y + s)
        @ic.line_to(x + s, y + 2*s/5)
        @ic.line_to(x, y + 2*s/5)
        @ic.line_to(x + 4*s/5, y + s)
        @ic.line_to(x + s/2, y)
        @ic.set_source_rgb(0, 0, 0)
        @ic.set_line_width(1.0)
        @ic.stroke_preserve()
        @ic.set_source_rgb(c)
        @ic.fill()
    end

    # Dessin d'une etiquette
    #
    # === Paramètres
    #
    # * +x+ - Position en x de l'étiquette
    # * +y+ - Position en y de l'étiquette
    # * +w+ - Largeur du rectangle
    # * +h+ - Hauteur du rectangle
    # * +s+ - Nombre d'étoiles
    def drawEtiquette(x, y, w, h, s)
        drawRectangle(x, y, w, h, 1.0)
        3.times() do |i| 
            i < s ? c = [1,1,0] : c = [0.5,0.5,0.5]
            drawEtoile(x + h*i + 4, y + 4, h - 8, c)
        end
    end

    # Clic sur la souris
	#
	# === Paramètres
	#
	# * +event+ => Evenement Gtk contenant les informations sur le clic
    def mouseClick(event)
    	puts(event.x, event.y)
    	puts(getVX(event.x), getVY(event.y))
    end
end
