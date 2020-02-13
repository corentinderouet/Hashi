require "gtk3"

# Widget Gtk permettant d'afficher une grille
class AfficheurGrille < Gtk::DrawingArea

	# Deux systèmes de positions sont utilisés dans le code:
	#
	# => Les positions "virtuelles" (vX, vY) qui correspondent aux coordonnées
	# 	 des cases (par exemple 0,0 pour la case en haut à gauche)
	#
	# => Les positions "réelles" (x, y) qui correspondent aux positions sur
	#    la fenêtre (en pixels) et qui changent en fonction de la résolution de l'écran
	#
	# Les méthodes getX, getY, getVX, getVY sont là pour passer entre ces deux systèmes

	# @grille => Grille à afficher
	# @vWidth => Largeur virtuelle de la grille
	# @vHeight => Hauteur virtuelle de la grille
	# @ratio => Ratio de la résolution actuelle
	# @vX => Nombre de pixel par coordonnée réelle horizontale
	# @vY => Nombre de pixel par coordonnée réelle verticale

	private

	# Constructeur
	#
	# === Parametres
	#
	# * +grille+ => Grille à afficher
	# * +vWidth+ => Largeur virtuelle de la grille (TODO à voir pour l'obtenir directement depuis la grille)
	# * +vHeight+ => Hauteur virtuelle de la grille (TODO à voir pour l'obtenir directement depuis la grille)
	def initialize(grille, vWidth, vHeight)
		super()
		@grille = grille
		@vWidth = vWidth
		@vHeight = vHeight
		@ratio = 1.0 * @vWidth / @vHeight
        self.signal_connect("draw") { |widget, cr| draw(cr) }
        self.signal_connect("button-press-event") { |widget, event| mouseClick(event) }
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
			return vX * @vY + (width - height * @ratio) / 2 + @vY
		else
			return vX * @vX + @vX
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
			return vY * @vX + (height - width / @ratio) / 2 + @vX
		else
			return vY * @vY + @vY
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
			return (x - (width - height * @ratio) / 2 - @vY) / @vY
		else
			return (x - @vX) / @vX
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
			return (y - (height - width / @ratio) / 2 - @vX) / @vX
		else
			return (y - @vY) / @vY
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

	# Dessin de la grille
	#
	# === Paramètres
	#
	# * +cr+ => Contexte sur lequel dessiner
    def draw(cr)
    	@vX = 1.0 * width / @vWidth
		@vY = 1.0 * height / @vHeight
    	cr.select_font_face("Arial", Cairo::FONT_SLANT_NORMAL, Cairo::FONT_WEIGHT_NORMAL)
        cr.set_font_size(scale(0.5))
        @grille.tabLien.each() do |l|
        	#l2 = @grille.lienSimilaire(l)
        	#if l2
        	#	drawLien(cr, l, -1)
        	#	drawLien(cr, l2, 1)
        	#else
        		drawLien(cr, l, 0)
        	#end
        end
        @grille.tabCase.each() { |c| drawCircle(cr, c) }
    end

    # Dessin d'un cercle
	#
	# === Paramètres
	#
	# * +cr+ => Contexte sur lequel dessiner
	# * +c+ => Cercle à dessiner
    def drawCircle(cr, c)
    	x = c.posX()
    	y = c.posY()
    	n = c.etiquetteCase()

    	cr.set_source_rgb(0, 0, 0)

    	#nord
    	if c.tabTriangle[0]
    		cr.move_to(getX(x), getY(y)-scale(0.45))
  			cr.line_to(getX(x) - scale(0.2), getY(y))
  			cr.line_to(getX(x) + scale(0.2), getY(y))
			cr.close_path()
			cr.fill()
		end
		#est
		if c.tabTriangle[1]
			cr.move_to(getX(x)+scale(0.45), getY(y))
	  		cr.line_to(getX(x), getY(y)- scale(0.2))
	  		cr.line_to(getX(x), getY(y)+ scale(0.2))
			cr.close_path()
			cr.fill()
		end
		#sud
		if c.tabTriangle[2]
			cr.move_to(getX(x), getY(y)+scale(0.45))
	  		cr.line_to(getX(x) - scale(0.2), getY(y))
	  		cr.line_to(getX(x) + scale(0.2), getY(y))
			cr.close_path()
			cr.fill()
		end
		#ouest
		if c.tabTriangle[3]
			cr.move_to(getX(x)-scale(0.45), getY(y))
	  		cr.line_to(getX(x), getY(y)- scale(0.2))
	  		cr.line_to(getX(x), getY(y)+ scale(0.2))
			cr.close_path()
			cr.fill()
		end

    	# Affichage bordure cercle
	    cr.arc(getX(x), getY(y), scale(0.3), 0, 2*Math::PI)
	    cr.fill()
	    # Affichage partie balnche cercle
	    cr.set_source_rgb(1, 1, 1)
	    cr.arc(getX(x), getY(y), scale(0.28), 0, 2*Math::PI)
	    cr.fill()
	    #Affichage numéro
	    cr.set_source_rgb(0, 0, 0)
	    cr.move_to(getX(x) - scale(0.14), getY(y) + scale(0.18))
	    cr.show_text(n.to_s())
    end

    # Dessin d'un lien
	#
	# === Paramètres
	#
	# * +cr+ => Contexte sur lequel dessiner
	# * +l+ => Lien à dessiner
	# * +offset+ => Décalage du lien
    def drawLien(cr, l, offset)
    	x1 = l.case1.posX()
    	y1 = l.case1.posY()
    	x2 = l.case2.posX()
    	y2 = l.case2.posY()

    	epaisseur = 0.02

    	if l.hypothese
    		puts("vert")
    		cr.set_source_rgb(0.2, 0.8, 0.2)
    	else
    		cr.set_source_rgb(0, 0, 0)
    	end

    	if lienHorizontal(l)
    		cr.rectangle(getX(x1), getY(y1)-scale(epaisseur/2), getX(x2)-getX(x1), scale(epaisseur))
    	else
	    	cr.rectangle(getX(x1)-scale(epaisseur/2), getY(y1), scale(epaisseur), getY(y2)-getY(y1))
	    end
	    
	    cr.fill()

	    # TODO Gestion deux liens
    end

    # Clic sur la souris
	#
	# === Paramètres
	#
	# * +event+ => Evenement Gtk contenant les informations sur le clic
    def mouseClick(event)
    	#puts(event.x, event.y)
    	#puts(getVX(event.x), getVY(event.y))
    	@grille.tabCase.each() do |c|
    		x = c.posX
    		y = c.posY

    		if (getVX(event.x) > x - 0.3) && (getVX(event.x) < x + 0.3) && (getVY(event.y) > y - 0.3) && (getVY(event.y) < y + 0.3)
    			puts("clic case")
    			#@grille.clicCase(c)
    		end

    		#haut
    		if c.tabTriangle[0] && (getVX(event.x) > x - 0.1) && (getVX(event.x) < x + 0.1) && (getVY(event.y) > y - 0.5) && (getVY(event.y) < y - 0.3)
    			puts("clic triangle haut")
    			#@grille.clicTriangle(c, 0)
    		end

    		#bas
    		if c.tabTriangle[2] && (getVX(event.x) > x - 0.1) && (getVX(event.x) < x + 0.1) && (getVY(event.y) > y + 0.3) && (getVY(event.y) < y + 0.5)
    			puts("clic triangle bas")
    			#@grille.clicTriangle(c, 2)
    		end

    		#gauche
    		if c.tabTriangle[3] && (getVX(event.x) > x - 0.5) && (getVX(event.x) < x - 0.3) && (getVY(event.y) > y - 0.1) && (getVY(event.y) < y + 0.1)
    			puts("clic triangle gauche")
    			#@grille.clicTriangle(c, 3)
    		end

    		#droite
    		if c.tabTriangle[1] && (getVX(event.x) > x + 0.3) && (getVX(event.x) < x + 0.5) && (getVY(event.y) > y - 0.1) && (getVY(event.y) < y + 0.1)
    			puts("clic triangle droite")
    			#@grille.clicTriangle(c, 1)
    		end
       	end

       	@grille.tabLien.each() do |l|
       		if l.case1.posX < l.case2.posX
       			x1 = l.case1.posX
    			x2 = l.case2.posX
    		else
    			x1 = l.case2.posX
    			x2 = l.case1.posX
    		end

    		if l.case1.posY < l.case2.posY
    			y1 = l.case1.posY
    			y2 = l.case2.posY
    		else
    			y1 = l.case2.posY
    			y2 = l.case1.posY
    		end

    		marge = 0.2

    		if y1 == y2
    			if (getVX(event.x) > x1 + 0.4) && (getVX(event.x) < x2 - 0.4) && (getVY(event.y) > y1 - marge) && (getVY(event.y) < y1 + marge)
    				puts("clic lien")
    				#@grille.clicLien(l)
    			end
    		else
    			if (getVX(event.x) > x1 - marge) && (getVX(event.x) < x1 + marge) && (getVY(event.y) > y1 + 0.4) && (getVY(event.y) < y2 - 0.4)
    				puts("clic lien")
    				#@grille.clicLien(l)
    			end
    		end
       	end
    end

    # Test si lien horizontal
    #
    # === Paramètres
    #
    # * +l+ => Lien à tester
    #
    # === Retour
    #
    # Retourne vrai si le lien est horizontal, faux sinon
    def lienHorizontal(l)
    	return l.case1.posX != l.case2.posX
    end
end