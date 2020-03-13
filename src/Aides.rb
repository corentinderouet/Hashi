#Classe représentant les aides
# Une aide :


class Aides

    attr_accessor:case
    
    attr_accessor:description


    private_class_method :new
    
    # Constructeur
  #
    def initialize(case,description)
        @case=case
        @description=description

    end

    # Redéfinition du constructeur
  #
    def Aides.creer(case,description)
        new(case,description)
    end





end
