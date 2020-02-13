load "Lien.rb"


# Une case du jeu avec des position ligne et colonne contenant une etiquette 
# correspondant au nombre de lien possible sur cette case
class Case

    # @ligne => entier correspondnant à la ligne de la case dans la grille
    # @colonne => entier correspondnant à la colonne de la case dans la grille
    # @etiquetteCase => entier correspondnant au nombre de lien total possible sur cette case
    # @tabVoisins => tableau(0 a 3) des cases voisines 
    # @tabTriangle => tableau(0 a 3) contenant des booleans correspondant a la possibilitée ou non de créer un lien dans une direction

    # Methode d ’ acces en lecture de @ligne
    attr_reader:ligne
    # Methode d ’ acces en lecture de @colonne
    attr_reader:colonne
    # Methode d ’ acces en lecture de @etiquetteCase
    attr_reader:etiquetteCase
    attr_accessor:tabVoisins
    attr_accessor:tabTriangle

    private_class_method:new

    def initialize(ligne,colonne,etiquetteCase)
        @ligne=ligne
        @colonne=colonne
        @etiquetteCase=etiquetteCase
        @tabTriangle=Array.new(4,false)
        @tabVoisins=Array.new(4,false)

    end

    def Case.creer(ligne,colonne,etiquetteCase)
        new(ligne,colonne,etiquetteCase)
    end

    def creerLien(posTabTriangle,hypothese,tabLien)
        if(self.tabTriangle[posTabTriangle]!=false)
            l=Lien.creer(self,self.tabVoisins[posTabTriangle],hypothese)
            c=0
            tabLien.each do  |lien|
                #  puts('recherche si le lien existe')
                if((lien.case1.ligne == self.ligne && lien.case1.colonne == self.colonne) && (lien.case2.ligne == self.tabVoisins[posTabTriangle].ligne && lien.case2.colonne == self.tabVoisins[posTabTriangle].colonne ) )
                    c +=1
                    #puts('il existe un lien de self vers la direction')
                elsif ((lien.case2.ligne == self.ligne && lien.case2.colonne == self.colonne) && (lien.case1.ligne == self.tabVoisins[posTabTriangle].ligne && lien.case1.colonne == self.tabVoisins[posTabTriangle].colonne ))
                    c +=1
                    #puts('il existe un lien de ladirection vers self')
                end
            end

            if(c==1)
                self.tabTriangle[posTabTriangle] = false
                self.tabVoisins[posTabTriangle].tabTriangle[(posTabTriangle + 2)%4] = false
            end
            tabLien.push(l)
        else
            puts('impossible de creer un lien entre ' "#{@etiquetteCase}"' et ' "#{self.tabVoisins[posTabTriangle].etiquetteCase}"' deja existant')
        end
    end

end