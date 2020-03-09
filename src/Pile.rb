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
          @pile.push(c)
      end

      def depiler()
          @pile.pop()
      end

      def afficherPile()
          @pile.each do |l|
              puts(l)
          end
      end

      def sommet()
          return @pile[0]
      end
end
