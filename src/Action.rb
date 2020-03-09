#Classe représentant une Action
# Une action :
#le nom de l'action (ajout,suppression,début ou fin d'hypothèse)
# le lien en question sur lequel l'action est appliquée

class Action

      attr_accessor:action
      attr_accessor:lien

      private_class_method :new
      
      # Constructeur
	#
	# === Parametres
	#
	# * +action+ => Action à faire
	# * +lien+ => Lien sur lequel faire l'action
      def initialize(action,lien)
          @action = action
          @lien = lien
      end

      # Redéfinition du constructeur
	#
	# === Parametres
	#
	# * +action+ => Action à faire
	# * +lien+ => Lien sur lequel faire l'action
      def Action.creer(action,lien)
          new(action,lien)
      end

      # Redéfinition de l'affichage d'une Action
      def to_s()
          return "#{@action}"
      end

end
