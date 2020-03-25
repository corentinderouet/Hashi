#Classe représentant les aides
# Une aide :


class Aides

    attr_accessor :caseJeu
    
    attr_accessor :description


    private_class_method :new
    
    # Constructeur
  #
    def initialize(caseJeu,description)
        @caseJeu = caseJeu
        @description = description

    end

    # Redéfinition du constructeur
  #
    def Aides.creer(caseJeu,description)
        new(caseJeu,description)
    end


    def to_s()
      return "#{@caseJeu} , #{@description}"
    end


end
