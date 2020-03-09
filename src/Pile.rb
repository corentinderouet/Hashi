class Pile

      attr_accessor:pile

      private_class_method :new

      def initialize()
          @pile = Array.new()
      end

      def Pile.creer()
          new()
      end

      def empiler(c)
          @pile.unshift(c)
      end

      def depiler()
          @pile.shift()
      end

      def estVide()
          return @pile.length()==0
      end

      def afficherPile()
            puts("\nAffichage pile :")
            @pile.each do |l|
                puts(l)
            end
      end

      def sommet()
          return @pile[0]
      end
end
