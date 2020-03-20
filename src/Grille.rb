require_relative "Case"
require_relative "Aides"
require_relative "Utilitaire"
require_relative "SerGrille"
require_relative "Pile"
require_relative "Action"

#Classe représentant une Grille
# Une grille peut :
# avoir une table des cases : méthode contientCaseAvecEtiquette
# avoir une table des liens entre les cases, et supprimer les liens
# commencer les hypotheses des liens, les valider ou annuler

class Grille

    # Méthode d'accès en lecture/écriture de @tabCase
    attr_accessor :tabCase
    # Méthode d'accès en lecture/écriture de @tabLien
    attr_accessor :tabLien
    # Méthode d'accès en lecture/écriture de @hypothese
    attr_accessor :hypothese

    # Méthode d'accès en lecture/écriture de @grilleRes
    attr_accessor :grilleRes

    attr_reader :hauteur

    attr_reader :largeur


    # Rend la méthode new privée
    private_class_method :new

    # Initialisation de la grille
    #
    # === Paramètres
    #
    # * +tab+ => la table des cases
    # * +hauteur+ => le nombre maximal des lignes de la grille
    # * +largeur+ => le nombre maximal des colonnes de la grille
    #
    def initialize(tab,hauteur,largeur,grilleRes)
        @hypothese=false
        @tabLien=Array.new()
        @tabCase=Array.new()
        @tabCase=tab
        @hauteur=hauteur
        @largeur=largeur
        @grilleRes=grilleRes
        @pile=Pile.creer()
        @pileRedo=Pile.creer()


        for i in 0..@tabCase.length-1 do
            for j in 0..@tabCase.length-1 do
                if(i !=j)
                    #on récupère le voisin le plus proche dans la direction nord
                    if((@tabCase[i].tabVoisins[0]==false && @tabCase[i].ligne>@tabCase[j].ligne && @tabCase[i].colonne==@tabCase[j].colonne) || ( @tabCase[i].ligne>@tabCase[j].ligne && @tabCase[i].colonne==@tabCase[j].colonne && @tabCase[j].ligne>@tabCase[i].tabVoisins[0].ligne ) )
                        @tabCase[i].tabVoisins[0]=@tabCase[j]
                        @tabCase[i].tabTriangle[0]=true
                    end
                    #on récupère le voisin le plus proche dans la direction Sud
                    if((@tabCase[i].tabVoisins[2]==false && @tabCase[i].ligne<@tabCase[j].ligne && @tabCase[i].colonne==@tabCase[j].colonne) || ( @tabCase[i].ligne<@tabCase[j].ligne && @tabCase[i].colonne==@tabCase[j].colonne && @tabCase[j].ligne<@tabCase[i].tabVoisins[2].ligne ) )
                        @tabCase[i].tabVoisins[2]=@tabCase[j]
                        @tabCase[i].tabTriangle[2]=true
                    end
                    #on récupère le voisin le plus proche dans la direction ouest
                    if((@tabCase[i].tabVoisins[3]==false && @tabCase[i].colonne>@tabCase[j].colonne && @tabCase[i].ligne==@tabCase[j].ligne) || ( @tabCase[i].colonne>@tabCase[j].colonne && @tabCase[i].ligne==@tabCase[j].ligne && @tabCase[j].colonne>@tabCase[i].tabVoisins[3].colonne ) )
                        @tabCase[i].tabVoisins[3]=@tabCase[j]
                        @tabCase[i].tabTriangle[3]=true
                    end
                    #on récupère le voisin le plus proche dans la direction est
                    if((@tabCase[i].tabVoisins[1]==false && @tabCase[i].colonne<@tabCase[j].colonne && @tabCase[i].ligne==@tabCase[j].ligne) || ( @tabCase[i].colonne<@tabCase[j].colonne && @tabCase[i].ligne==@tabCase[j].ligne && @tabCase[j].colonne<@tabCase[i].tabVoisins[1].colonne ) )
                        @tabCase[i].tabVoisins[1]=@tabCase[j]
                        @tabCase[i].tabTriangle[1]=true
                    end
                end
            end
        end
    end

    # Méthode de création d'une grille
    #
    # === Paramètres
    #
    # * +tab+ => la table des cases
    # * +hauteur+ => le nombre maximal des lignes de la grille
    # * +largeur+ => le nombre maximal des colonnes de la grille
    #
    def Grille.creer(tab,hauteur,largeur,grilleRes)
        new(tab,hauteur,largeur,grilleRes)
    end

    # Méthode d'affichage de la table des cases
    #
    def tabCaseAfficher()
        for i in 0..@tabCase.length-1
            puts(tabCase[i])
        end
    end

    # Méthode qui trouve une case selon ses coordonnées
    #
    # === Paramètres
    #
    # * +ligne+ => la position dans la grille
    # * +colonne+ => la position dans la grille
    #
    def caseIci(ligne, colonne)
        @tabCase.each do |c|
            if(c.ligne==ligne && c.colonne==colonne)
                return c
            end
        end
    end

    # Méthode de suppression des liens entres les cases
    #
    # === Paramètres
    #
    # * +l+ => le lien à supprimer
    #
    def supprimerLien(l)
        i=Utilitaire.index(@tabLien,l)
        x=Utilitaire.index(@tabCase,@tabLien[i].case1)
        y=Utilitaire.index(@tabCase,@tabLien[i].case2)
        #on peut remplacer par l.case1 et l.case2 au lieu des indices
        @tabLien.delete_at(i)

        self.actuCroisement()

    end

    # Méthode pour remplir la table des cases avec une valeur
    #
    # === Paramètres
    #
    # * +ligne+ => entier correspondant la ligne d'une case de la grille
    # * +colonne+ => entier correspondant la colonne d'une case de la grille
    #
    # === Retour
    #
    # Retourne la valeur de la case, sinon retour faux
    #
    def contientCaseAvecEtiquette(ligne,colonne)
        for i in 0..@tabCase.length-1 do
            if(@tabCase[i].ligne==ligne && @tabCase[i].colonne==colonne)
                return @tabCase[i]
            end
        end
        return false
    end


    # Méthode lors d'un clic sur un cercle
    #
    # === Paramètres
    #
    # * +case1+ => la case du clic
    # * +tabLien2+ => le tableau qui va contenir les liens à mettre en surbrillance
    #
    # === Retour
    #rien
    #
    def clicCercle(case1,tabLien2)#a modifier pour afficher toutes les cases reliées
        for i in 0..3 do
            if(case1.tabVoisins[i]!=false)
                if(case1.nbLienEntreDeuxCases(@tabLien,i) != 0 )
                    c=0
                    #on push le ou les lien(s) si ils ne sont pas dans le tabLien2
                    @tabLien.each do  |lien|
                        if((lien.case1.ligne == case1.ligne && lien.case1.colonne == case1.colonne) && (lien.case2.ligne == case1.tabVoisins[i].ligne && lien.case2.colonne == case1.tabVoisins[i].colonne ) )
                            if( Utilitaire.index(tabLien2,lien)==-1 )#probleme ici
                                tabLien2.push(lien)
                                c +=1
                            end
                        elsif ((lien.case2.ligne == case1.ligne && lien.case2.colonne == case1.colonne) && (lien.case1.ligne == case1.tabVoisins[i].ligne && lien.case1.colonne == case1.tabVoisins[i].colonne ))
                            if( Utilitaire.index(tabLien2,lien)==-1 )#probleme ici
                                tabLien2.push(lien)
                                c +=1
                            end
                        end

                    end

                    if(c!=0)
                        clicCercle(case1.tabVoisins[i],tabLien2)
                    end
                end
            end
        end
        return
    end

    # Méthode lors d'un dlic sur le triangle d'un cercle
    #
    # === Paramètres
    #
    # * +case1+ => la case du clic
    # * +pos+ => entier correspondant la position du lien de deux cases
    #
    def clicTriangle(case1,pos)
        l=case1.creerLien(pos,@hypothese,@tabLien)
        @pile.empiler(Action.creer("ajout",l))
        #@pile.afficherPile()
        @pileRedo.vider()
        self.actuCroisement()
    end

    # actualise les triangles de chaques cases pour empecher les croisements de liens
    #
    def actuCroisement()

        @tabCase.each do |c|
            if(c.etiquetteCase.to_i() > c.nbLienCase(@tabLien) )
                for i in 0..3 do
                    if(c.tabVoisins[i]!=false)
                        c.tabTriangle[i]=true
                    else
                        c.tabTriangle[i]=false
                    end
                end
            end

            for i in 0..3 do
                if(c.tabTriangle[i]==true)
                    if(c.nbLienEntreDeuxCases(@tabLien,i)<=1 && c.etiquetteCase.to_i() > c.nbLienCase(@tabLien))
                        c.tabTriangle[i]=true
                    else
                        c.tabTriangle[i]=false
                    end
                end
            end


            for i in 0..3 do
                if(c.tabTriangle[i]==true)
                    if(c.lienPasseEntreDeuxCases(@tabLien,i)==false && c.etiquetteCase.to_i() > c.nbLienCase(@tabLien) && c.nbLienEntreDeuxCases(@tabLien,i)<=1)
                        c.tabTriangle[i]=true
                    else
                        c.tabTriangle[i]=false
                    end
                end
            end


        end

        @tabCase.each do |c|
            for i in 0..3 do
                if(c.tabVoisins[i]!=false && c.tabVoisins[i].tabTriangle[(i+2)%4]==false)
                    c.tabTriangle[i]=false
                end
            end

        end


    end


    # Méthode lors du clic sur un lien pour supprimer ce dernier
    #
    # === Paramètres
    #
    # * +l+ => le lien qui a été cliqué
    #
    def clicLien(l)
        @pile.empiler(Action.creer("suppression",l))
        self.supprimerLien(l)
        @pileRedo.vider()
        #@pile.afficherPile()
    end

    # Méthode pour commencer à faire une hypothèse
    #
    def commencerHypothese()
        @pile.empiler(Action.creer("debutHypothese",nil))
        @hypothese=true
    end

    # Méthode pour valider une hypothèse
    #
    def validerHypothese()
        for i in 0..@tabLien.length-1 do
            if(@tabLien[i].hypothese==true)
                @tabLien[i].hypothese=false
            end
        end
        @pile.empiler(Action.creer("hypotheseValidee",nil) )
        #@pile.afficherPile()
        @hypothese=false
    end

    # Méthode permettant de savoir si un lien est entre les même case qu'un autre (ATTENTION : retourne nil s'il est le seul)
    #
    # === Paramètres
    #
    # * +l+ => un lien
    #
    # === Retour
    #
    # Retourne le lien si c'est le même, sinon nil
    #
    def lienSimilaire(l)
        @tabLien.each do |lien|
            if(l!=lien  && (lien.case1==l.case1 && lien.case2==l.case2) || (lien.case1==l.case2 && lien.case2==l.case1))
                return lien
            end
        end
        return nil
    end

    def lememeLien(l,tab)
      tab.each do |lien|
          if((lien.case1==l.case1 && lien.case2==l.case2) || (lien.case1==l.case2 && lien.case2==l.case1))
              return lien
          end
      end
      return nil
    end


    def verification()
        #revien d'action en action au dernier etat correct
        unePile= Marshal.load(Marshal.dump(@pile))
        pileInverser=Pile.creer()
        pileCorrect=Pile.creer()

        unePile.each do |action|
            pileInverser.empiler(action)
        end

        i=0
        while(i!=1 && pileInverser.sommet() !=nil)
            a= pileInverser.depiler()
            if(a.action =="ajout")
                if(self.lememeLien(a.lien,@grilleRes.tabLien) != nil)
                    pileCorrect.empiler(a)
                else
                    i +=1
                end
            end
        end
        @pile.vider()
        @pile=pileCorrect


    end




    # Méthode pour annuler une hypothèse
    #
    def annulerHypothese() #pas encore fonctionnelle

        a = @pile.sommet()
        while(a.action != "debutHypothese")
            if(a.action == "ajout")
                self.supprimerLien( a.lien )
            end

            if(a.action == "suppression")
                a.lien.case1.creerLien(Utilitaire.index(a.lien.case1.tabVoisins,a.lien.case2),a.lien.hypothese,@tabLien)
            end

            @pile.depiler()
            a = @pile.sommet()
        end
        @pile.depiler()
        
        

        @hypothese=false
    end


    # Méthode pour annuler une action (Undo)
    #
    def annuler()

        if( !@pile.estVide() )
            a = @pile.sommet()

            @pileRedo.empiler(a) #quand on depile en Undo on doit empiler en Redo

            #puts("Sommet pile : #{a}")

            if(a.action == "ajout")
                @pile.depiler()
                self.supprimerLien( a.lien )
            end

            if(a.action == "suppression")
                @pile.depiler()
                a.lien.case1.creerLien(Utilitaire.index(a.lien.case1.tabVoisins,a.lien.case2),a.lien.hypothese,@tabLien)
            end

            if(a.action == "hypotheseValidee")

                @pile.depiler()
                a = @pile.sommet()
                @pileRedo.empiler(a)
                while(a.action != "debutHypothese")
                    if(a.action == "ajout")
                        self.supprimerLien( a.lien )
                    end

                    if(a.action == "suppression")
                        a.lien.case1.creerLien(Utilitaire.index(a.lien.case1.tabVoisins,a.lien.case2),a.lien.hypothese,@tabLien)
                    end

                    @pile.depiler()
                    a = @pile.sommet()
                    @pileRedo.empiler(a)
                end
                @pile.depiler()
            end

        end

        #@pile.afficherPile()
    end


    # Méthode pour refaire une action (Redo)
    #
    def refaire()

        
        if( !@pileRedo.estVide() )
            a = @pileRedo.sommet()
            @pile.empiler(a)    #quand on depile en Redo on doit empiler en Undo
            #puts("Sommet pile : #{a}")

            if(a.action == "ajout")
                @pileRedo.depiler()
                a.lien.case1.creerLien(Utilitaire.index(a.lien.case1.tabVoisins,a.lien.case2),a.lien.hypothese,@tabLien)
                
            end

            if(a.action == "suppression")
                @pileRedo.depiler()
                self.supprimerLien( a.lien )
            end

            if(a.action == "hypotheseValidee")

                @pileRedo.depiler()
                a = @pileRedo.sommet()
                @pile.empiler(a)
                while(a.action != "debutHypothese")
                    if(a.action == "ajout")
                        a.lien.case1.creerLien(Utilitaire.index(a.lien.case1.tabVoisins,a.lien.case2),a.lien.hypothese,@tabLien)
                    end
        
                    if(a.action == "suppression")
                        self.supprimerLien( a.lien )
                    end

                    @pileRedo.depiler()
                    a = @pileRedo.sommet()
                    @pile.empiler(a)
                end
                @pileRedo.depiler()
            end

        end

        #@pileRedo.afficherPile()

    end


    # Méthode pour réénitialiser tout la grille et les actions (en gros nouveau départ)
    #
    def reenitialiser()
        for i in 0..@tabLien.length-1 do
            self.clicLien(@tabLien[i])
        end
        @pile.vider()
        @pileRedo.vider()
    end


    #methode pour les aides
    #
    # === Paramètres
    #
    # * +niveau+ => un entier correspondant au niveau de complexité de l'aide retourné
    # si niveau ==1,2 ou 3 prend une aide au niveau correspondante sinon aide de niveau aléatoire, si tableau aide vide, retourne aide niveau sup
    #
    # === Retour
    #
    # Retourne un objet Aides
    #
    def obtenirAide(niveau) 
        aides1=Array.new() #aide qui utilise l'etiquette de la case et sa postion dans la grille
        aides2=Array.new() #aide qui utilise l'etiquette de la case et sa liste de voisins
        aides3=Array.new() #aide qui utilise l'etiquette de la case et sa liste de voisins ainsi que toute l'archipelle


        #on génere les aides par rapport a la grille actuel ici, on va push toutes les aides possibles dans les tableaux correspondant à leurs difficultés

        @tabCase.each do |c|    
            #if( c.nbVoisinsDispo()==1 && ( (c.etiquetteCase.to_i==1 && c.nbLienCase(@tabLien)<1) || (c.etiquetteCase.to_i==2 && c.nbLienCase(@tabLien)<2) ) ) 
               # aides2.push( Aides.creer(c," Si une case possède 1 voisins et a une étiquette de 2 ou moins, il est possible de créer 1 lien ou plus ") )
            #end

            if( c.nbLienCase(@tabLien)==0 && ( (c.nbVoisinsDispo()==1 && c.etiquetteCase.to_i==2 && c.nbLienCase(@tabLien)<2) || (c.nbVoisinsDispo()==2 && c.etiquetteCase.to_i==4 && c.nbLienCase(@tabLien)<4) || (c.nbVoisinsDispo()==3 && c.etiquetteCase.to_i==6 && c.nbLienCase(@tabLien)<6) || (c.nbVoisinsDispo()==4 && c.etiquetteCase.to_i==8 && c.nbLienCase(@tabLien)<8) ) ) 
                aides1.push( Aides.creer(c," Si une case possède une etiquette pair et un nombre de voisins étant la moitier de l'étiquette, il est possible de créer 2 liens vers chaques voisins ") )
            end#a modif

            if( c.nbVoisinsDispo()==1 && c.etiquetteCase.to_i>c.nbLienCase(@tabLien) ) 
                aides1.push( Aides.creer(c," Si une case possède 1 voisin et a une etiquette supérieur au nombre de lien déja créer, il est possible de créer 1 lien au moins vers ce voisin ") )
            end

            if( c.nbVoisinsDispo()==2 && c.etiquetteCase.to_i==3 && c.nbLienCase(@tabLien)==0 ) 
                aides2.push( Aides.creer(c," Si une case possède 2 voisins et a une etiquette de 3, il est possible de créer 1 lien au moins vers chaques voisins ") )
            end#a modif

            if( c.nbVoisinsDispo()==3 && c.etiquetteCase.to_i==5 && c.nbLienCase(@tabLien)<3 ) 
                aides2.push( Aides.creer(c," Si une case possède 3 voisins et a une etiquette de 5, il est possible de créer 1 lien au moins vers chaques voisins ") )
            end

            if( c.nbVoisinsDispo()==4 && c.etiquetteCase.to_i==7 && c.nbLienCase(@tabLien)<4 ) 
                aides2.push( Aides.creer(c," Si une case possède 4 voisins et a une etiquette de 7, il est possible de créer 1 lien au moins vers chaques voisins ") )
            end

            if( c.nbVoisinsDispo()==2 && (c.etiquetteCase.to_i==2 || c.etiquetteCase.to_i==3) && c.nbLienCase(@tabLien)==0 && c.voisinsDispoEtiDe1()==true ) 
                aides2.push( Aides.creer(c," Si une case ayant une etiquette de 2 ou 3 possède 2 voisins dont un ayant une etiquette de 1, il est possible de créer l'etiquette-1 lien(s) vers l'autre voisin ") )
            end

           # if( c.nbVoisinsDispo()==2 && ((c.etiquetteCase.to_i==2 && c.nbLienCase(@tabLien)==0) || (c.etiquetteCase.to_i==3 && c.nbLienCase(@tabLien)==0))  && c.auMoinsUnVoisinDispoUnLienRestant(@tabLien)==true ) 
                #aides3.push( Aides.creer(c," Si une case possède 2 voisins et a une etiquette de 2 ou 3, il est possible de déterminer où créer un lien en fonction du nombre de lien déja présent sur ses voisins  ") )
            #end
            
            

        end
        #on retourne une aides en fonction du niveau ici

        if(niveau==1 && aides1.length==0)
            niveau+=1
        end
        if(niveau==2 && aides2.length==0)
            niveau+=1
        end
        if(niveau==3 && aides3.length==0)
            return Aides.creer(@tabCase[0],"Aucune aide disponible pour le moment")
        end

        case(niveau)
            when 1
                return aides1[rand(0..(aides1.length-1) )]
            when 2
                return aides2[rand(0..(aides2.length-1) )]
            when 3
                return aides3[rand(0..(aides3.length-1) )]
            else
                alea=1

                if(alea==1 && aides1.length==0)
                    alea+=1
                end
                if(alea==2 && aides2.length==0)
                    alea+=1
                end
                if(alea==3 && aides3.length==0)
                    return Aides.creer(@tabCase[0],"Aucune aide disponible pour le moment")
                end

                case(alea)
                    when 1
                        return aides1[rand(0..(aides1.length-1) )]
                    when 2
                        return aides2[rand(0..(aides2.length-1) )]
                    when 3
                        return aides3[rand(0..(aides3.length-1) )]
                end
        end
    end













end
