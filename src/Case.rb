require_relative "Lien"


# Une case du jeu avec des position ligne et colonne contenant une etiquette
# correspondant au nombre de lien possible sur cette case
class Case

    # @ligne => entier correspondnant à la ligne de la case dans la grille
    # @colonne => entier correspondnant à la colonne de la case dans la grille
    # @etiquetteCase => entier correspondnant au nombre de lien total possible sur cette case
    # @tabVoisins => tableau(0 a 3) des cases voisines
    # @tabTriangle => tableau(0 a 3) contenant des booleans correspondant a la possibilitée ou non de créer un lien dans une direction

    # Méthode d'acces en lecture de @ligne
    attr_reader :ligne
    # Méthode d'acces en lecture de @colonne
    attr_reader :colonne
    # Méthode d'acces en lecture de @etiquetteCase
    attr_reader :etiquetteCase
    # Méthode d'acces en lecture / ecriture de @tabVoisins
    attr_accessor :tabVoisins
    # Méthode d'acces en lecture / ecriture de @tabTriangle
    attr_accessor :tabTriangle

    # On rend privé la méthode de classe new pour forcer l'utilisation de Case.creer
    private_class_method :new

    # Initialisation d'une case
    #
    # === Parametres
    #
    # * + ligne + = > la ligne de la case dans la grille
    # * + colonne + = > la colonne de la case dans la grille
    # * + etiquetteCase + = > le nombre de liens total pouvant être relié à cette case
    #
    def initialize(ligne,colonne,etiquetteCase)
        @ligne=ligne
        @colonne=colonne
        @etiquetteCase=etiquetteCase
        @tabTriangle=Array.new(4,false)
        @tabVoisins=Array.new(4,false)

    end


    # Création d'une case
    #
    # === Parametres
    #
    # * + ligne + = > la ligne de la case dans la grille
    # * + colonne + = > la colonne de la case dans la grille
    # * + etiquetteCase + = > le nombre de liens total pouvant être reliés à cette case
    #
    # === Retour
    #
    # La case créée
    #
    def Case.creer(ligne,colonne,etiquetteCase)
        new(ligne,colonne,etiquetteCase)
    end


    # compte le nombre de voisins disponible
    #
    # === Retour
    #
    # entier correspondant au nombre de voisins dispo(donc la ou il y a un triangle)
    #
    def nbVoisinsDispo()
        compteur=0
        @tabTriangle.each do |t|
            if(t!=false)
                compteur+=1
            end
        end
        return compteur
    end





    # compte le nombre de voisins
    #
    # === Retour
    #
    # entier correspondant au nombre de voisins(triangle ou pas)
    #
    def nbVoisins()
        compteur=0
        @tabVoisins.each do |v|
            if(v!=false)
                compteur+=1
            end
        end
        return compteur
    end


    # compte le nb de voisins dispo de la case possèdant une certaine étiquette
    #
    # === Parametres
    #
    # * + etiquette + = > l'etiquette à test
    #
    # === Retour
    #
    # entier sur le nombre de voisins possédant cette etiquette
    #
    def voisinsDispoEtiDe(etiquette)
        compteur=0
        for i in 0..3 do
            if(@tabTriangle[i]==true && @tabVoisins[i].etiquetteCase.to_i==etiquette)
                compteur+=1
            end
        end
        return compteur
    end


    # compte le nb de voisins déja   relié par un moins un lien
    #
    # === Parametres
    #
    # * + tabLien + = > le tableau des liens
    #
    # === Retour
    #
    # entier sur le nombre de voisins déja relié
    #
    def nbCaseDejaRelie(tabLien)
        compteur=0
        for i in 0..3 do
            if(@tabVoinsins[i]!=false && self.nbLienEntreDeuxCases(tabLien,i)!=0  )
                compteur+=1
            end
        end
        return compteur
    end


        # compte le nb de voisins pas encore relié par un moins un lien
    #
    # === Parametres
    #
    # * + tabLien + = > le tableau des liens
    #
    # === Retour
    #
    # entier sur le nombre de voisins non relié
    #
    def nbCasePasDejaRelie(tabLien)
        compteur=0
        for i in 0..3 do
            if(@tabTriangle[i]==true && self.nbLienEntreDeuxCases(tabLien,i)==0  )
                compteur+=1
            end
        end
        return compteur
    end





    # test si au moin au de ses voisins DISPO ne peux creer plus que 1 lien
    #
    # === Parametres
    #
    # * + tabLien + = > le tableau des liens
    #
    # === Retour
    #
    # boolean sur ce test
    #
    def auMoinsUnVoisinDispoUnLienRestant(tabLien)
        for i in 0..3 do
            if(@tabTriangle[i]==true && @tabVoisins[i].etiquetteCase.to_i - 1 ==@tabVoisins[i].nbLienCase(tabLien) && @tabVoisins[i].nbVoisinsDispo()==1 )
                return true
            end
        end
        return false
    end



    # Compte le nombre de lien encore possible vers cette case
    #
    # === Parametres
    #
    # * + tabLien + = > le tableau des liens
    #
    # === Retour
    #
    # Le nombre de liens possible
    #
    def nbLienCasePossible(tabLien)
        compteur=0
        for i in 0..3 do
            if(@tabTriangle[i]==true )
                val=( 2 - self.nbLienEntreDeuxCases(tabLien,i) )
                if(val > (@tabVoisins[i].etiquetteCase.to_i-@tabVoisins[i].nbLienCase(tabLien)) )
                    val=(@tabVoisins[i].etiquetteCase.to_i-@tabVoisins[i].nbLienCase(tabLien))
                end
                compteur+= val
            end
        end
        return compteur
    end


    # Compte le nombre de liens attachés à une case
    #
    # === Parametres
    #
    # * + tabLien + = > le tableau des liens
    #
    # === Retour
    #
    # Le nombre de liens
    #
    def nbLienCase(tabLien)
        compteur=0
        tabLien.each do |lien|
            if( self==lien.case1 || self==lien.case2 )
                compteur+=1
            end
        end
        return compteur
    end

    # Calcule le nombre de liens entre une case et une direction, les tests sont à faire avant l'appel de la méthode
    #
    # === Parametres
    #
    # * + posTabTriangle + = > entier correspondant à la direction de création du lien (0==nord,1==est,2==sud,3==ouest)
    # * + tabLien + = > le tableau de liens de la grille
    #
    # === Retour
    #
    # Nombre entre 0 et 2 compris
    #
    def nbLienEntreDeuxCases(tabLien,posTabTriangle)
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
        return c
    end
    


    def lienPasseEntreDeuxCases(tabLien,posTabTriangle)
        if(@tabTriangle[posTabTriangle]!=false)
            tabLien.each do  |lien|
                if( (@ligne>lien.case1.ligne && @ligne<lien.case2.ligne) || (@ligne<lien.case1.ligne && @ligne>lien.case2.ligne) )
                    if(posTabTriangle==1 && lien.case1.colonne-lien.case2.colonne==0 && lien.case1.colonne>@colonne && lien.case1.colonne< @tabVoisins[posTabTriangle].colonne)
                        return true
                    end
                    if(posTabTriangle==3 && lien.case1.colonne-lien.case2.colonne==0 && lien.case1.colonne<@colonne && lien.case1.colonne> @tabVoisins[posTabTriangle].colonne)
                        return true
                    end
                end
                if( (@colonne>lien.case1.colonne && @colonne<lien.case2.colonne) || (@colonne<lien.case1.colonne && @colonne>lien.case2.colonne) )
                    if(posTabTriangle==0 && lien.case1.ligne-lien.case2.ligne==0 && lien.case1.ligne<@ligne && lien.case1.ligne> @tabVoisins[posTabTriangle].ligne)
                        return true
                    end
                    if(posTabTriangle==2 && lien.case1.ligne-lien.case2.ligne==0 && lien.case1.ligne>@ligne && lien.case1.ligne< @tabVoisins[posTabTriangle].ligne)
                        return true
                    end
                end
            end
        end
        return false
    end


    # Création d'un lien à partir de cette case dans une certaine direction
    #
    # === Paramètres
    #
    # * + posTabTriangle + = > entier qui correspond à la direction de création du lien (0==nord,1==est,2==sud,3==ouest)
    # * + hypothese + = > boolean qui correspond à l'état du lien, si il est créé ou non lors d'une hypothèse
    # * + tabLien + = > le tableau de liens de la grille
    #
    def creerLien(posTabTriangle,hypothese,tabLien)
        if(self.tabTriangle[posTabTriangle]!=false)
            l=Lien.creer(self,self.tabVoisins[posTabTriangle],hypothese)

            c=self.nbLienEntreDeuxCases(tabLien,posTabTriangle)

            if(c==1)
                self.tabTriangle[posTabTriangle] = false
                self.tabVoisins[posTabTriangle].tabTriangle[(posTabTriangle + 2)%4] = false
            end
            tabLien.push(l)

            return l
        else
            puts('impossible de creer un lien entre ' "#{@etiquetteCase}"' et ' "#{self.tabVoisins[posTabTriangle].etiquetteCase}"' deja existant')
        end

    end



    def to_s()
        return "Case en [#{@ligne},#{@colonne}] : etiq[#{@etiquetteCase}]"
    end



end
