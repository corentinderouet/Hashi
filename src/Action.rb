#Classe représentant une Action
# Une action :
#le nom de l'action (ajout,suppresion,debut ou fin d'hypothese)
# le lien en question sur lequel l'action est appliquee

class Action

      attr_accessor:action
      attr_accessor:lien

      private_class_method :new

      def initialize(action,lien)
          @action = action
          @lien = lien
      end

      def Action.creer(action,lien)
          new(action,lien)
      end

      def to_s()
          return "#{@action}"
      end

end
