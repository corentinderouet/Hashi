require "gtk3"
require_relative "Carte"

# Widget Gtk affichant le monde
class Monde < Carte

    # @factZoom => Facteur de zoom
    # @dX => Décalage de l'affichage en x
    # @dY => Décalage de l'affichage en y

    # Constructeur
    #
    # === Paramètres
    #
    # * +carte+ - Carte principale
    def initialize(carte)
        super(carte)
        @dX = -2383
        @dY = -1950
        @factZoom = 0.5

        self.dessinerEtiquettes()
    end

    def dessinerEtiquettes()
        # Amérique du nord
        self.drawRectangleVide(380, 900, 1300, 950, false)
        n = @carte.etoiles[0].first(7).inject(:+)
        self.drawTexte(380 + 1300/2, 900 + 950/2, "Amérique du nord : #{n}/21")

        # Amérique du sud
        @bAmeriqueSud = @carte.nbEtoiles >= 12
        self.drawRectangleVide(1150, 1870, 700, 950, !@bAmeriqueSud)
        if @bAmeriqueSud
          n = @carte.etoiles[0].last(7).inject(:+)
          self.drawTexte(1150 + 700/2, 1820 + 950/2, "Amérique du sud")
          self.drawTexte(1150 + 700/2, 1920 + 950/2, "#{n}/21")
        else
          self.drawTexte(1150 + 700/2, 1870 + 950/2, "12 pour débloquer")
        end

        # Europe
        @bEurope = @carte.nbEtoiles >= 24
        self.drawRectangleVide(1980, 900, 850, 680, !@bEurope)
        if @bEurope
            n = @carte.etoiles[1].first(7).inject(:+)
            self.drawTexte(1980 + 850/2, 900 + 680/2, "Europe : #{n}/21")
        else
            self.drawTexte(1980 + 850/2, 900 + 680/2, "24 pour débloquer")
        end

        # Asie
        @bAsie = @carte.nbEtoiles >= 36
        self.drawRectangleVide(2850, 750, 1200, 1350, !@bAsie)
        if @bAsie
            n = @carte.etoiles[1].last(7).inject(:+)
            self.drawTexte(2850 + 1200/2, 750 + 1350/2, "Asie : #{n}/21")
        else
            self.drawTexte(2850 + 1200/2, 750 + 1350/2, "36 pour débloquer")
        end

        # Océanie
        @bOceanie = @carte.nbEtoiles >= 48
        self.drawRectangleVide(3375, 2120, 950, 550, !@bOceanie)
        if @bOceanie
            n = @carte.etoiles[1].first(7).inject(:+)
            self.drawTexte(3375 + 950/2, 2120 + 550/2, "Océanie : #{n}/21")
        else
            self.drawTexte(3375 + 950/2, 2120 + 550/2, "48 pour débloquer")
        end

        # Afrique
        @bAfrique = @carte.nbEtoiles >= 60
        self.drawRectangleVide(1980, 1600, 850, 900, !@bAfrique)
        if @bAfrique
          n = @carte.etoiles[1].last(8).first(7).inject(:+)
            self.drawTexte(1980 + 850/2, 1600 + 900/2, "Afrique : #{n}/21")
        else
            self.drawTexte(1980 + 850/2, 1600 + 900/2, "60 pour débloquer")
        end
        
        # Antarctique
        if @bAfrique
            @bAntarctique = @carte.nbEtoiles >= 120
            self.drawRectangleVide(1980, 3000, 850, 200, !@bAntarctique)
            if @bAntarctique
                n = @carte.etoiles[1].last.inject(:+)
                self.drawTexte(1980 + 850/2, 3000 + 200/2, "Antarctique : #{n}/3")
            else
                self.drawTexte(1980 + 850/2, 3000 + 200/2, "120 pour débloquer")
            end
        end
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
        x = getVX(event.x)
        y = getVY(event.y)

        # Europe
        if x > 1980 && y >  900 && x < 1980+850 && y < 900+680
            if @bEurope == true
                s = "europe"
            else
                s = "null"
            end
            # Afrique
        elsif x > 1980 && y > 1600 && x < 1980+850 && y < 1600+900
            if @bAfrique == true
                s = "afrique"
            else
                s = "null"
            end
            # Asie
        elsif x > 2850 && y > 750 && x < 2850+1200 && y < 750+1350
            if @bAsie == true
                s = "asie"
            else
                s = "null"
            end
            # Océanie
        elsif x > 3375 && y > 2120 && x < 3375+950 && y < 2120+550
            if @bOceanie == true
                s = "oceanie"
            else
                s = "null"
            end
            # Amérique du nord
        elsif x > 380 && y > 900 && x < 380+1300 && y < 900+950
            s = "ameriqueNord"
            # Amérique du sud
        elsif x > 1150 && y > 1870 && x < 1150+700 && y < 1870+950
            if @bAmeriqueSud == true
                s = "ameriqueSud"
            else
                s = "null"
            end
            # Antarctique
        elsif x > 1980 && y > 3000 && x < 1980+850 && y < 3000+200
            if @bAntarctique == true
                s = "antarctique"
            else
                s = "null"
            end
        end
        if s
            if s != "null"
              @carte.choix(s)
            end
        end
    end
end
