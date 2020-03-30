require "gtk3"
require_relative "Etiquette"

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
    
    # Constructeur
    #
    # === Paramètres
    #
    # * +carte+ - carte principale
    def initialize(carte)
        super()
        @etiquettes = []
        @carte = carte
        self.signal_connect("draw") { |widget, cr| draw(cr) }
        self.signal_connect("button-press-event") { |widget, event| mouseClick(event); self.queue_draw(); }
        self.events = :all_events_mask
        @image = Cairo::ImageSurface.from_png("../assets/map.png")
        @ic = Cairo::Context.new(@image)
    end

    def refresh()
        @image = Cairo::ImageSurface.from_png("../assets/map.png")
        @ic = Cairo::Context.new(@image)
        self.dessinerEtiquettes()
        self.queue_draw()
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
        #@zoom = @factZoom * width / height / 2
        if height*1.3 > width
          @zoom = @factZoom * (width / 5000.0) * 2.5
        else
          @zoom = @factZoom * (height / 2000.0) * 1.5
        end
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
    def drawRectangle(x, y, w, h)
        radius = h / 10.0
        degrees = Math::PI / 180.0;

        @ic.new_sub_path()
        @ic.arc(x + w - radius, y + radius, radius, -90 * degrees, 0 * degrees)
        @ic.arc(x + w - radius, y + h - radius, radius, 0 * degrees, 90 * degrees)
        @ic.arc(x + radius, y + h - radius, radius, 90 * degrees, 180 * degrees)
        @ic.arc(x + radius, y + radius, radius, 180 * degrees, 270 * degrees)
        @ic.close_path()

        #@ic.set_source_rgb(1, 1, 1)
        @ic.set_source_rgba(0.1328125, 0.1328125, 0.1328125, 0.5)
        @ic.fill_preserve()
        #@ic.set_source_rgb(0, 0, 0)
        @ic.set_source_rgb(0.9375, 0.328125, 0.296875)
        @ic.set_line_width(2.0)
        @ic.stroke()
    end

    # Dessin d'un rectangle vide
    #
    # === Paramètres
    #
    # * +x+ - Position en x du rectangle
    # * +y+ - Position en y du rectangle
    # * +w+ - Largeur du rectangle
    # * +h+ - Hauteur du rectangle
    # * +c+ - Couleurs inversées ou non
    def drawRectangleVide(x, y, w, h, c)
        radius = h / 10.0
        degrees = Math::PI / 180.0;

        @ic.new_sub_path()
        @ic.arc(x + w - radius, y + radius, radius, -90 * degrees, 0 * degrees)
        @ic.arc(x + w - radius, y + h - radius, radius, 0 * degrees, 90 * degrees)
        @ic.arc(x + radius, y + h - radius, radius, 90 * degrees, 180 * degrees)
        @ic.arc(x + radius, y + radius, radius, 180 * degrees, 270 * degrees)
        @ic.close_path()

        if c == false
            @ic.set_source_rgba(0.1328125, 0.1328125, 0.1328125, 0.5)
            @ic.fill_preserve()
            @ic.set_source_rgb(0.9375, 0.328125, 0.296875)
            @ic.set_line_width(10.0)
            @ic.stroke()
        else 
            @ic.set_source_rgba(0.1328125, 0.1328125, 0.1328125, 0.5)
            @ic.fill_preserve()
            @ic.set_source_rgb(0, 0, 0)
            @ic.set_line_width(10.0)
            @ic.stroke()

        end
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
    # * +e+ - Etiquette à dessiner
    def drawEtiquette(e)
        drawRectangle(e.x, e.y, e.w, e.h)
        3.times() do |i| 
            i < e.s ? c = [0.9375, 0.328125, 0.296875] : c = [0.5,0.5,0.5]
            drawEtoile(e.x + e.h*i + 4, e.y + 4, e.h - 8, c)
        end
    end

    # Ajout d'une etiquette
    #
    # === Paramètres
    #
    # * +e+ - Etiquette à ajouter
    def ajouterEtiquette(e)
        @etiquettes.append(e)
    end

    # Dessin des étiquettes
    def dessinerEtiquettes()
        @etiquettes.each() { |x| drawEtiquette(x) }
    end

    # Affichage de texte
    #
    # === Paramètres
    #
    # * +x+ - Coordonnée en x
    # * +y+ - Coordonnée en y
    # * +t+ - Texte à afficher
    def drawTexte(x, y, t)
        @ic.set_font_size(70)
        @ic.text_extents(t)

        @ic.move_to(x - @ic.text_extents(t).width/2, y + @ic.text_extents(t).height/2)
        @ic.show_text(t)
    end

    # Clic sur la souris
    #
    # === Paramètres
    #
    # * +event+ => Evenement Gtk contenant les informations sur le clic
    def mouseClick(event)
        #puts(event.x, event.y)
        #puts(getVX(event.x), getVY(event.y))
        x = getVX(event.x)
        y = getVY(event.y)
        @etiquettes.each() do |e|
            if x > e.x && y > e.y && x < (e.x + e.w) && y < (e.y + e.h)
                @carte.lancer(e.g)
                return nil
            end
        end

        @carte.retour()
    end
end
