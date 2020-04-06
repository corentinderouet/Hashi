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

    # @tabCase => tableau contenant les cases (objet Case)
    # @tabLien => tableau contenant les liens (objet Lien)
    # @hypothese => boolean correspondnant a l'état du jeu, en mode hypothese ou non
    # @grilleRes => object Grille contenant la grille finie et correcte
    # @hauteur => entier, hauteur de la grille
    # @largeur => entier, largeur de la grille
    # @timer => entier, temps déja passé sur la grille en seconde
    # @grilleFini => boolean correspondant a l'état de la grille, si elle est fini ou non (et correcte)
    # @nbAides => entier, représentant le nombre d'aides déja utilisées


    # Méthodes d'accès en lecture/écriture de @tabCase
    attr_accessor :tabCase
    # Méthodes d'accès en lecture/écriture de @tabLien
    attr_accessor :tabLien
    # Méthodes d'accès en lecture/écriture de @hypothese
    attr_accessor :hypothese

    # Méthodes d'accès en lecture/écriture de @grilleRes
    attr_accessor :grilleRes

    # Méthode d'accès en lecture de @hauteur
    attr_reader :hauteur

    # Méthode d'accès en lecture de @largeur
    attr_reader :largeur

    # Méthodes d'accès en lecture/écriture de @timer
    attr_accessor :timer

    # Méthodes d'accès en lecture/écriture de @grilleFini
    attr_accessor :grilleFinie

    # Méthodes d'accès en lecture/écriture de @nbAides
    attr_accessor :nbAides

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
        #@tabCase=Array.new() # Inutile avec la ligne d'en dessous
        @tabCase=tab
        @hauteur=hauteur
        @largeur=largeur
        @grilleFinie=false
        @grilleRes=grilleRes
        @pile=Pile.creer()
        @pileRedo=Pile.creer()
        @timer ||= 0
        @nbAides ||= 0


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

        self.actuCroisement()

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
    # === Retour
    #
    # Retourne la case sinon retourne faux
    #
    def caseIci(ligne, colonne)
        @tabCase.each do |c|
            if(c.ligne==ligne && c.colonne==colonne)
                return c
            end
        end
        return false
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
    # Retourne la valeur de la case, sinon retourne faux
    #
    def contientCaseAvecEtiquette(ligne,colonne)
        for i in 0..@tabCase.length-1 do
            if(@tabCase[i].ligne==ligne && @tabCase[i].colonne==colonne)
                return @tabCase[i]
            end
        end
        return false
    end


    # Méthode lors d'un clic sur un cercle/une case
    #
    # === Paramètres
    #
    # * +case1+ => la case du clic
    # * +tabLien2+ => le tableau qui va contenir les liens à mettre en surbrillance
    #
    # === Retour
    #rien
    #
    def clicCercle(case1,tabLien2)
        for i in 0..3 do
            if(case1.tabVoisins[i]!=false)
                if(case1.nbLienEntreDeuxCases(@tabLien,i) != 0 )
                    c=0
                    #on push le ou les lien(s) si ils ne sont pas dans le tabLien2
                    @tabLien.each do  |lien|
                        if((lien.case1.ligne == case1.ligne && lien.case1.colonne == case1.colonne) && (lien.case2.ligne == case1.tabVoisins[i].ligne && lien.case2.colonne == case1.tabVoisins[i].colonne ) )
                            if( Utilitaire.index(tabLien2,lien)==-1 )
                                tabLien2.push(lien)
                                c +=1
                            end
                        elsif ((lien.case2.ligne == case1.ligne && lien.case2.colonne == case1.colonne) && (lien.case1.ligne == case1.tabVoisins[i].ligne && lien.case1.colonne == case1.tabVoisins[i].colonne ))
                            if( Utilitaire.index(tabLien2,lien)==-1 )
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



    # test si une archipelle n'est pas complète(c'est a dire qu'il reste au moins un triangle dans l'archipelle))
    #
    # === Paramètres
    #
    # * +case1+ => la case du clic
    # * +tabCase2+ => le tableau qui va contenir les case deja test
    #
    # === Retour
    #   boolean sur le test
    #
    def ArchiNonComplete(case1,tabCase2)
        if(case1.nbVoisinsDispo()==0)
            if(tabCase2.include?(case1)==false)
                tabCase2.push(case1)
            end
            for i in 0..3 do
                if(case1.tabVoisins[i]!=false && case1.nbLienEntreDeuxCases(@tabLien,i) != 0 )
                    if(tabCase2.include?(case1.tabVoisins[i])==false)
                        if(ArchiNonComplete(case1.tabVoisins[i],tabCase2)==true)
                            return true
                        end
                    end

                end
            end
        else
            return true
        end
        
        return false
    end




    # Méthode appelée lors d'un clic sur le triangle d'un cercle/une case
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

    # actualise les triangles de chaques cases pour empecher les croisements de liens et met à jours les autres triangles.
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


    # Méthode appelée lors du clic sur un lien pour le supprimer
    #
    # === Paramètres
    #
    # * +l+ => le lien qui a été cliqué
    #
    def clicLien(l)
        @pile.empiler(Action.creer("suppression",l))
        self.supprimerLien(l)
        @pileRedo.vider()
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


    # Méthode permettant de savoir si un lien est présent dans un tableau de lien en comparent les coordonée des cases
    #
    # === Paramètres
    #
    # * +l+ => un lien
    # * +tab+ => un tableau de ;lien
    #
    # === Retour
    # un lien ou null
    # 
    def leMemeLien(l,tab)
      tab.each do |lien|
          if((lien.case1.ligne==l.case1.ligne && lien.case1.colonne==l.case1.colonne && lien.case2.ligne==l.case2.ligne && lien.case2.colonne==l.case2.colonne) || (lien.case1.ligne==l.case2.ligne && lien.case1.colonne==l.case2.colonne && lien.case2.ligne==l.case1.ligne && lien.case2.colonne==l.case1.colonne))
              return lien
          end
      end
      return nil
    end




    # Méthode permettant de tester si la grille est terminée ou non
    #
    # === Retour
    # boolean correspondant au test
    # 
    def grilleFinie?()
        if( self.nbErreurGrille()==0 && @tabLien.length==@grilleRes.tabLien.length )
            @grilleFinie=true
            return true
        end

        return false
      end






    # Méthode permettant de savoir le nb d'erreur sur la grille
    #
    # === Retour
    # entier correspondant au nombre d'erreur
    # 
    def nbErreurGrille()
        nbErreur=0

        tabRes=Marshal.load(Marshal.dump(@grilleRes.tabLien))

        @tabLien.each do |lien|

            l=leMemeLien(lien,tabRes)
            if( l!=nil )
                tabRes.delete(l)
            else
                nbErreur+=1
            end

        end

        return nbErreur
    end



    # Méthode permettant de retourner au dernier etat correct de la grille
    #
    # === Retour
    # entier correspondant au nombre d'erreur lors de l'appel de la methode
    # 
    def verification()
        val=nbErreurGrille()
        while(self.nbErreurGrille()!=0 )
            self.annuler()
        end
        @pileRedo.vider()
        return val

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
                self.actuCroisement()
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

            if(a.action == "ajout")
                @pile.depiler()
                self.supprimerLien( a.lien )
            end

            if(a.action == "suppression")
                @pile.depiler()
                a.lien.case1.creerLien(Utilitaire.index(a.lien.case1.tabVoisins,a.lien.case2),a.lien.hypothese,@tabLien)
                self.actuCroisement()
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
                        self.actuCroisement()
                    end

                    @pile.depiler()
                    a = @pile.sommet()
                    @pileRedo.empiler(a)
                end
                @pile.depiler()
            end

        end

    end


    # Méthode pour refaire une action (Redo)
    #
    def refaire()

        
        if( !@pileRedo.estVide() )
            a = @pileRedo.sommet()
            @pile.empiler(a)    #quand on depile en Redo on doit empiler en Undo

            if(a.action == "ajout")
                @pileRedo.depiler()
                a.lien.case1.creerLien(Utilitaire.index(a.lien.case1.tabVoisins,a.lien.case2),a.lien.hypothese,@tabLien)
                self.actuCroisement()
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
                        self.actuCroisement()
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


    end


    # Méthode pour réinitialiser toute la grille et les actions (en gros nouveau départ)
    #
    def reinitialiser()
        for i in 0..@tabLien.length-1 do
            self.clicLien(@tabLien[i])
        end
        @pile.vider()
        @pileRedo.vider()
    end


    #methode pour les aides
    #
    # === Retour
    #
    # Retourne un objet Aides
    #
    def obtenirAide() 
        aides1=Array.new() #aide qui utilise l'etiquette de la case et sa postion dans la grille
        aides2=Array.new() #aide qui utilise l'etiquette de la case et sa liste de voisins
        aides3=Array.new() #aide qui utilise l'etiquette de la case et sa liste de voisins ainsi que toute l'archipelle

        niveau=1


        #on génere les aides par rapport a la grille actuelle ici, on push toutes les aides possibles dans les tableaux correspondant à leurs difficultés

        @tabCase.each do |c| 
            if( (c.etiquetteCase.to_i - c.nbLienCase(@tabLien))!=0 )   


                #=================NIVEAU 1==============#


                #bon
                if( c.nbVoisinsDispo()==1 && c.etiquetteCase.to_i>c.nbLienCase(@tabLien) ) 
                    aides1.push( Aides.creer(1,c,"Si une case avec une etiquette de #{c.etiquetteCase} possède exactement un voisin et possède encore au moins un pont créable; il est possible de créer tous les liens restants")) #" Si une case possède 1 voisin et a une etiquette supérieur au nombre de lien déja créer, il est possible de créer tous les liens restants vers ce voisin ") )
                end

                #bon
                if( (c.etiquetteCase.to_i - c.nbLienCase(@tabLien)) == c.nbLienCasePossible(@tabLien) )
                    aides1.push( Aides.creer(1,c,"Si une case avec une etiquette de #{c.etiquetteCase} possède autant de ponts créables que (l'étiquette - ponts); il est possible de créer tous les liens restants")) #" Si une case possède un nombre de lien restant possible vers elle égale à son etiquette moins le nombre de lien déja créé sur cette case, il est possible de créer tous les liens restant.") )
                end

               





                #A OPTI avec boucle for

                if( c.etiquetteCase.to_i - c.nbLienCase(@tabLien) == 3 &&  c.nbVoisinsDispo()==2  )
                    aides1.push( Aides.creer(1,c," Si une case possède une valeur de 3 correspondant à son etiquette moins le nombre de liens vers des directions déja completes et 2 voisins, il est possible de créer au moins un lien vers chaque voisins ") )
                end

                if( c.etiquetteCase.to_i - c.nbLienCase(@tabLien) ==2 &&  c.nbVoisinsDispo()==2 && c.nbCasePasDejaRelie(@tabLien)==1  )
                    aides1.push( Aides.creer(1,c," Si une case possède une valeur de 3 correspondant à son etiquette moins le nombre de liens vers des directions déja completes et 2 voisins, il est possible de créer au moins un lien vers chaque voisins ") )
                end






                if( c.etiquetteCase.to_i - c.nbLienCase(@tabLien) == 5 &&  c.nbVoisinsDispo()==3  )
                    aides1.push( Aides.creer(1,c," Si une case possède une valeur de 5 correspondant à son etiquette moins le nombre de liens vers des directions déja completes et 3 voisins, il est possible de créer au moins un lien vers chaque voisins ") )
                end

                if( c.etiquetteCase.to_i - c.nbLienCase(@tabLien) == 4 &&  c.nbVoisinsDispo()==3 && c.nbCasePasDejaRelie(@tabLien)==2 )
                    aides1.push( Aides.creer(1,c," Si une case possède une valeur de 5 correspondant à son etiquette moins le nombre de liens vers des directions déja completes et 3 voisins, il est possible de créer au moins un lien vers chaque voisins ") )
                end

                if( c.etiquetteCase.to_i - c.nbLienCase(@tabLien) == 3 &&  c.nbVoisinsDispo()==3 && c.nbCasePasDejaRelie(@tabLien)==1 )
                    aides1.push( Aides.creer(1,c," Si une case possède une valeur de 5 correspondant à son etiquette moins le nombre de liens vers des directions déja completes et 3 voisins, il est possible de créer au moins un lien vers chaque voisins ") )
                end




                if( c.etiquetteCase.to_i - c.nbLienCase(@tabLien) == 7 &&  c.nbVoisinsDispo()==4  )
                    aides1.push( Aides.creer(1,c," Si une case possède une valeur de 7 correspondant à son etiquette moins le nombre de liens vers des directions déja completes et 4 voisins, il est possible de créer au moins un lien vers chaque voisins ") )
                end

                if( c.etiquetteCase.to_i - c.nbLienCase(@tabLien) == 6 &&  c.nbVoisinsDispo()==4 && c.nbCasePasDejaRelie(@tabLien)==3 )
                    aides1.push( Aides.creer(1,c," Si une case possède une valeur de 7 correspondant à son etiquette moins le nombre de liens vers des directions déja completes et 4 voisins, il est possible de créer au moins un lien vers chaque voisins ") )
                end

                if( c.etiquetteCase.to_i - c.nbLienCase(@tabLien) == 5 &&  c.nbVoisinsDispo()==4 && c.nbCasePasDejaRelie(@tabLien)==2 )
                    aides1.push( Aides.creer(1,c," Si une case possède une valeur de 7 correspondant à son etiquette moins le nombre de liens vers des directions déja completes et 4 voisins, il est possible de créer au moins un lien vers chaque voisins ") )
                end

                if( c.etiquetteCase.to_i - c.nbLienCase(@tabLien) == 4 &&  c.nbVoisinsDispo()==4 && c.nbCasePasDejaRelie(@tabLien)==1 )
                    aides1.push( Aides.creer(1,c," Si une case possède une valeur de 7 correspondant à son etiquette moins le nombre de liens vers des directions déja completes et 4 voisins, il est possible de créer au moins un lien vers chaque voisins ") )
                end




                #=================NIVEAU 2==============#



                #en cours

                if( (c.etiquetteCase.to_i - c.nbLienCase(@tabLien)) ==4 && c.nbVoisinsDispo()==3 && c.nbVoisinsDispoEtiDe(2)>=2 && c.nbCasePasDejaRelie(@tabLien)==3 ) 
                    aides2.push( Aides.creer(2,c,"Si une case possède une valeur de 4 correspondant à son etiquette moins le nombre de liens vers des directions déja completes et possède 3 voisins dont deux avec des etiquettes de 2, il est possible de créer un lien vers le troisieme voisin ") )
                end

                if( (c.etiquetteCase.to_i - c.nbLienCase(@tabLien)) ==3 && c.nbVoisinsDispo()==3 && c.nbVoisinsDispoEtiDe(2)>=2 && c.nbCasePasDejaRelie(@tabLien)==2 && !c.lienDifDeFois(2,2,@tabLien) ) 
                    aides2.push( Aides.creer(2,c,"Si une case possède une valeur de 4 correspondant à son etiquette moins le nombre de liens vers des directions déja completes et possède 3 voisins dont deux avec des etiquettes de 2, il est possible de créer un lien vers le troisieme voisin ") )
                end

                if( (c.etiquetteCase.to_i - c.nbLienCase(@tabLien)) ==2 && c.nbVoisinsDispo()==3 && c.nbVoisinsDispoEtiDe(2)>=2 && c.nbCasePasDejaRelie(@tabLien)==1 && !c.lienDifDeFois(2,2,@tabLien) ) 
                    aides2.push( Aides.creer(2,c,"Si une case possède une valeur de 4 correspondant à son etiquette moins le nombre de liens vers des directions déja completes et possède 3 voisins dont deux avec des etiquettes de 2, il est possible de créer un lien vers le troisieme voisin ") )
                end












#exemple de phrase: "Cette case #{c.etiquetteCase} possède exactement 2 voisins dont au moins un avec une étiquette 2; il est donc possible de créer 1 pont vers l'autre voisin"
                #bon
                if( c.etiquetteCase.to_i==2 && c.nbVoisinsDispo()==2 && c.nbVoisinsDispoEtiDe(2)==2 && c.nbLienCase(@tabLien)==0) 
                    aides2.push( Aides.creer(2,c,"Si une case avec une etiquette de 2 possède 2 voisins qui sont deux case avec des etiquettes de 2, il est possible de créer un lien vers chaque voisin ") )
                end


                #bon
                if( c.etiquetteCase.to_i==2 && c.nbVoisinsDispo()==2 && c.nbVoisinsDispoEtiDe(2)==1 && c.nbLienCase(@tabLien)==0) 
                    aides2.push( Aides.creer(2,c,"Si une case avec une etiquette de 2 et 0 lien possède 2 voisins dont un SEUL avec une etiquette de 2, il est possible de créer un lien vers l'autre voisin ") )
                end


                if( c.etiquetteCase.to_i==2 && c.nbVoisinsDispo()==2 && c.nbVoisinsDispoEtiDe(1)==1 && c.nbLienCase(@tabLien)==0) 
                    aides2.push( Aides.creer(2,c,"Si une case avec une etiquette de 2 possède 2 voisins dont un avec une etiquette de 1, il est possible de créer un lien vers l'autre voisins ") )
                end





                #=================NIVEAU 3==============#



                
                if( self.testArchipel1(c) )
                    aides3.push( Aides.creer(3,c," Si lors de la création d'un lien la suite du jeu est bloqué car une archipelle complette est formé(suite de case sans triangle restant relié par des liens) , il est possible de déterminer ou créer un lien ") )
                end


                if( self.testArchipel2(c) )
                    aides3.push( Aides.creer(3,c," Si lors de la création de deux liens sur une case avec 2 voisins et 2 liens restant max a construire la suite du jeu est bloqué car une archipelle complette est formé(suite de case sans triangle restant relié par des liens) , il est possible de déterminer ou créer au moins un lien") )
                end

                if( self.testArchipel3(c) )
                    aides3.push( Aides.creer(3,c," Si lors de la création de quatre liens sur une case avec 3 voisins et 4 liens restant max a construire la suite du jeu est bloqué car une archipelle complette est formé(suite de case sans triangle restant relié par des liens) , il est possible de déterminer ou créer au moins un lien") )
                end


            end

        end


        #on retourne une aides en fonction du niveau

        if(niveau==1 && aides1.length==0)
            niveau+=1
        end
        if(niveau==2 && aides2.length==0)
            niveau+=1
        end
        if(niveau==3 && aides3.length==0)
            return Aides.creer(1,@tabCase[0],"Aucune aide disponible pour le moment, il est conseillé de faire une verification car les aides s'adaptent à votre grille actuelle.")
        end

        case(niveau)
            when 1
                return aides1[rand(0..(aides1.length-1) )]
            when 2
                return aides2[rand(0..(aides2.length-1) )]
            when 3
                return aides3[rand(0..(aides3.length-1) )]
        end
    end






        # test si une seule solution est possible sur une case dans le cadre de la creation de liens pour eviter les archipelles completes avec creation d'un unique lien
    #
    # === Parametres
    #
    # * + case + = > la case pour le test
    #
    # === Retour
    #
    # boolean sur le test
    #
    def testArchipel1(case1)
        compteur=0


        if(case1.nbLienCase(@tabLien)==case1.etiquetteCase.to_i-1)

            for i in 0..3 do
                if(case1.tabTriangle[i]==true)
                    lien=case1.creerLien(i,false,tabLien)
                    self.actuCroisement()
                    if( ArchiNonComplete(case1,Array.new()) )
                        compteur+=1
                    end
                    supprimerLien(lien)
                end
            end

        end

        if(compteur==1)
            return true
        end
        return false
    end


    # test si une seule solution est possible sur une case dans le cadre de la creation de liens pour eviter les archipelles completes avec creation de deux liens
    #
    # === Parametres
    #
    # * + case + = > la case pour le test
    #
    # === Retour
    #
    # boolean sur le test
    #
    def testArchipel2(case1)

        if(case1.nbLienCase(@tabLien)==case1.etiquetteCase.to_i-2 && case1.nbVoisinsDispo()==2 && case1.nbCasePasDejaRelie(@tabLien)==2 && case1.nbVoisinsDispoEtiRestanteDe(1,@tabLien)==0  )
            compteur=0
            for i in 0..3 do
                if(case1.tabTriangle[i]==true)

                    lien=case1.creerLien(i,false,tabLien)
                    lien2=case1.creerLien(i,false,tabLien)

                    self.actuCroisement()
                    if( ArchiNonComplete(case1,Array.new()) )
                        compteur+=1
                    end
 
                    supprimerLien(lien)
                    supprimerLien(lien2)


                end
            end

            if(compteur==0 || compteur==1)
                return true
            end

        end

        return false
    end


    # test si une seule solution est possible sur une case dans le cadre de la création de liens pour eviter les archipelles complètes avec création de deux liens dans plusieurs directions
    #
    # === Paramètres
    #
    # * + case + = > la case pour le test
    #
    # === Retour
    #
    # boolean sur le test
    #
    def testArchipel3(case1)

        if(case1.nbLienCase(@tabLien)==case1.etiquetteCase.to_i-4 && case1.nbVoisinsDispo()==3 && case1.nbCasePasDejaRelie(@tabLien)==3 && case1.nbVoisinsDispoEtiRestanteDe(1,@tabLien)==0  )
            compteur=0
            for i in 0..3 do
                for j in 0..3 do

                    if(case1.tabTriangle[i]==true && case1.tabTriangle[j]==true && i!=j)
                        lien=case1.creerLien(i,false,tabLien)
                        lien2=case1.creerLien(i,false,tabLien)
                        lien3=case1.creerLien(j,false,tabLien)
                        lien4=case1.creerLien(j,false,tabLien)
                    

                        self.actuCroisement()
                        if( !ArchiNonComplete(case1,Array.new()) )
                            compteur+=1
                        end
    
                        supprimerLien(lien)
                        supprimerLien(lien2)
                        supprimerLien(lien3)
                        supprimerLien(lien4)


                    end

                end
            end

            if(compteur>=1)
                return true
            end

        end

        return false
    end










end
