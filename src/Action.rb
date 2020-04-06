#Classe représentant une Action
# Une action :
#le nom de l'action (ajout,suppression,début ou fin d'hypothèse)
# le lien en question sur lequel l'action est appliquée

class Action

    # @action => String, représente le type d'action
    # @lien => Lien, le lien sur lequel a été appliqué l'action


    # Méthode d'acces en lecture / ecriture de @action
    attr_accessor :action
    # Méthode d'acces en lecture / ecriture de @lien
    attr_accessor :lien
        
    # On rend privé la méthode de classe new pour forcer l'utilisation de Action.creer
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
