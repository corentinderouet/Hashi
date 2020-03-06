
#Représente un lien entre deux cases qui peut être un lien hypothèse
class Lien

    # @case1 => correspond à la première case à laquelle est reliée ce lien
    # @case2 => correspond à la deuxième case à laquelle est reliée ce lien
    # @hypothese => booléen sur l'état du lien, si il est une hypothese(true) ou pas(false)

    # Méthode d'acces en lecture de @case1
    attr_reader :case1
    # Méthode d'acces en lecture de @case2
    attr_reader :case2
    # Meéhode d'acces en lecture / écriture de @hypothese
    attr_accessor :hypothese

    # On rend privé la méthode de classe new pour forcer l'utilisation de Lien.creer
    private_class_method :new


    # Initialisation d'un lien
    #
    # === Parametres
    #
    # * +case1+ => case de départ du lien
    # * +case2+ => case d'arrivé du lien
    # * +hypothese+ => booléen, vrai si le lien est une hypothèse, faux sinon
    #
    def initialize(case1,case2,hypothese)
        @case1=case1
        @case2=case2
        @hypothese=hypothese
    end

    
    # Création d'un lien
    #
    # === Paramètres
    #
    # * +case1+ => case de départ du lien
    # * +case2+ => case d'arrivé du lien
    # * +hypothese+ => booléen, vrai si le lien est une hypothèse, faux sinon
    #
    # === Retour
    #
    # Le lien créé
    #
    def Lien.creer(case1,case2,hypothese)
        new(case1,case2,hypothese)
    end


    # Affiche les informations d'un lien
    #
    def to_s()
        return "(Lien : [#{@case1.ligne},#{@case1.colonne}]-[#{@case2.ligne},#{@case2.colonne}], #{self.hypothese})\n"
    end
end
