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
    # @surbrillance => Liens à mettre en surbrillance

    attr_accessor :cercleAide

    private

    # Constructeur
    #
    # === Parametres
    #
    # * +grille+ => Grille à afficher
    # * +playable+ => Réagit au clics de souris ou non
    # * +jeu+ => L'afficheur de jeu si la grille est utilisé en tant que jeu
    def initialize(grille, playable, jeu)
        super()
        @playable = playable
        @jeu = jeu
        @surbrillance = []
        @grille = grille
        @vWidth = grille.largeur
        @vHeight = grille.hauteur
        @ratio = 1.0 * @vWidth / @vHeight
        @cercleAide = nil
        self.signal_connect("draw") { |widget, cr| draw(cr) }
        self.signal_connect("button-press-event") { |widget, event| mouseClick(event); self.queue_draw() } if @playable
        self.events = :all_events_mask
    end

    # Passage en état jouable
    def setPlayable()
        if !@playable
            self.signal_connect("button-press-event") { |widget, event| mouseClick(event); self.queue_draw() }
            @playable = true
        end
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
        t = []
        @grille.tabLien.each() do |l|
            if !t.include?(l)
                l2 = @grille.lienSimilaire(l)
                if l2
                    drawLien(cr, l, -0.075)
                    drawLien(cr, l2, 0.075)
                    t.append(l2)
                else
                    drawLien(cr, l, 0)
                end
            end
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
        x = c.colonne()
        y = c.ligne()
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
        saturee?(c) ? cr.set_source_rgb(0.5, 0.5, 0.5) : cr.set_source_rgb(0, 0, 0)
        cr.set_source_rgb(0,1,0) if c == @cercleAide
        cr.arc(getX(x), getY(y), scale(0.3), 0, 2*Math::PI)
        cr.fill()
        # Affichage partie balnche cercle
        saturee?(c) ? cr.set_source_rgb(0.75, 0.75, 0.75) : cr.set_source_rgb(1, 1, 1)
        cr.arc(getX(x), getY(y), scale(0.28), 0, 2*Math::PI)
        cr.fill()
        #Affichage numéro
        saturee?(c) ? cr.set_source_rgb(0.5, 0.5, 0.5) : cr.set_source_rgb(0, 0, 0)
        cr.set_source_rgb(0,1,0) if c == @cercleAide
        cr.move_to(getX(x) - scale(0.14), getY(y) + scale(0.18))
        cr.show_text(n.to_s())
    end

    def saturee?(c)
        return true if c.nbLienCase(@grille.tabLien) >= c.etiquetteCase.to_i()
        return false
    end

    # Dessin d'un lien
    #
    # === Paramètres
    #
    # * +cr+ => Contexte sur lequel dessiner
    # * +l+ => Lien à dessiner
    # * +offset+ => Décalage du lien
    def drawLien(cr, l, offset)
        x1 = l.case1.colonne()
        y1 = l.case1.ligne()
        x2 = l.case2.colonne()
        y2 = l.case2.ligne()

        epaisseur = 0.02

        if l.hypothese
            cr.set_source_rgb(0.2, 0.8, 0.2) # Couleur verte
        else
            cr.set_source_rgb(0, 0, 0)
        end

        if @surbrillance.include?(l)
            cr.set_source_rgb(0.8,0.2,0.2)
        end

        if lienHorizontal(l)
            cr.rectangle(getX(x1), getY(y1)-scale(epaisseur/2)+scale(offset), getX(x2)-getX(x1), scale(epaisseur))
        else
            cr.rectangle(getX(x1)-scale(epaisseur/2)+scale(offset), getY(y1), scale(epaisseur), getY(y2)-getY(y1))
        end

        cr.fill()
    end

    # Clic sur la souris
    #
    # === Paramètres
    #
    # * +event+ => Evenement Gtk contenant les informations sur le clic
    def mouseClick(event)
        #puts(event.x, event.y)
        #puts(getVX(event.x), getVY(event.y))
        @surbrillance = []
        @grille.tabCase.each() do |c|
            x = c.colonne
            y = c.ligne

            if (getVX(event.x) > x - 0.3) && (getVX(event.x) < x + 0.3) && (getVY(event.y) > y - 0.3) && (getVY(event.y) < y + 0.3)
                @grille.clicCercle(c, @surbrillance)
                @jeu.aJoue()
                return
            end

            #haut
            if c.tabTriangle[0] && (getVX(event.x) > x - 0.1) && (getVX(event.x) < x + 0.1) && (getVY(event.y) > y - 0.5) && (getVY(event.y) < y - 0.3)
                @grille.clicTriangle(c,0)
                @jeu.aJoue()
                return
            end

            #bas
            if c.tabTriangle[2] && (getVX(event.x) > x - 0.1) && (getVX(event.x) < x + 0.1) && (getVY(event.y) > y + 0.3) && (getVY(event.y) < y + 0.5)
                @grille.clicTriangle(c,2)
                @jeu.aJoue()
                return
            end

            #gauche
            if c.tabTriangle[3] && (getVX(event.x) > x - 0.5) && (getVX(event.x) < x - 0.3) && (getVY(event.y) > y - 0.1) && (getVY(event.y) < y + 0.1)
                @grille.clicTriangle(c,3)
                @jeu.aJoue()
                return
            end

            #droite
            if c.tabTriangle[1] && (getVX(event.x) > x + 0.3) && (getVX(event.x) < x + 0.5) && (getVY(event.y) > y - 0.1) && (getVY(event.y) < y + 0.1)
                @grille.clicTriangle(c,1)
                @jeu.aJoue()
                return
            end
        end

        @grille.tabLien.each() do |l|
            if l.case1.colonne < l.case2.colonne
                x1 = l.case1.colonne
                x2 = l.case2.colonne
            else
                x1 = l.case2.colonne
                x2 = l.case1.colonne
            end

            if l.case1.ligne < l.case2.ligne
                y1 = l.case1.ligne
                y2 = l.case2.ligne
            else
                y1 = l.case2.ligne
                y2 = l.case1.ligne
            end

            marge = 0.2

            if y1 == y2
                if (getVX(event.x) > x1 + 0.4) && (getVX(event.x) < x2 - 0.4) && (getVY(event.y) > y1 - marge) && (getVY(event.y) < y1 + marge)
                    @grille.clicLien(l)
                    @jeu.aJoue()
                    return
                end
            else
                if (getVX(event.x) > x1 - marge) && (getVX(event.x) < x1 + marge) && (getVY(event.y) > y1 + 0.4) && (getVY(event.y) < y2 - 0.4)
                    @grille.clicLien(l)
                    @jeu.aJoue()
                    return
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
        return l.case1.colonne != l.case2.colonne
    end
end
