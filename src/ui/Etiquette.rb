# Etiquette pour les différents niveaux en mode aventure
class Etiquette

    attr_reader :x, :y, :w, :h, :s, :g

    # Constructeur
    #
    # === Paramètres
    #
    # * +x+ - Position en x de l'étiquette
    # * +y+ - Position en y de l'étiquette
    # * +w+ - Largeur du rectangle
    # * +h+ - Hauteur du rectangle
    # * +s+ - Nombre d'étoiles
    # * +g+ - Grille à jouer
    def initialize(x, y, w, h, s, g)
        @x = x
        @y = y
        @w = w
        @h = h
        @s = s
        @g = g
    end
end
