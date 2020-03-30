#Classe représentant les aides
# Une aide :


class Aides

    attr_accessor :caseJeu
    
    attr_accessor :description

    attr_accessor :niveau #1,2 ou 3 de facile a difficile

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


    def to_s()
      return "#{@niveau} : #{@caseJeu}, #{@description}"
    end


end
