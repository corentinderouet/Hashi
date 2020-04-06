#Classe représentant les aides
# Une aide :


class Aides

    # @casejeu => Case, représente la case sur laquelle s'applique l'aide
    # @description => String, représente une courte phrase proposant une technique à appliquer 
    # @niveau => entier(1 à 3), représente le niveau de l'aide, 3 étant le niveau d'aide le plus complexe.

    # Méthodes d'acces en lecture / ecriture de @caseJeu
    attr_accessor :caseJeu
    # Méthodes d'acces en lecture / ecriture de @description
    attr_accessor :description
    # Méthodes d'acces en lecture / ecriture de @niveau
    attr_accessor :niveau #1,2 ou 3 de facile a difficile
    # On rend privé la méthode de classe new pour forcer l'utilisation de Aides.creer
    private_class_method :new
    
    # Constructeur
    #
    def initialize(niveau,caseJeu,description)
        @niveau=niveau
        @caseJeu = caseJeu
        @description = description

    end

    # Redéfinition du constructeur
    #
    def Aides.creer(niveau,caseJeu,description)
        new(niveau,caseJeu,description)
    end

    # Redéfinition de l'affichage d'une Aides
    def to_s()
      return "#{@niveau} : #{@caseJeu}, #{@description}"
    end


end
