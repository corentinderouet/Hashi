load'Case.rb'
load'Utilitaire.rb'
load "SerGrille.rb"

class Grille
    attr_accessor:tabCase
    attr_accessor:tabLien
    attr_accessor:hypothese


    private_class_method:new


    def initialize(tab)
        @hypothese=false
        @tabLien=Array.new()
        @tabCase=Array.new()
        @tabCase=tab


        for i in 0..@tabCase.length-1 do
            for j in 0..@tabCase.length-1 do
                if(i !=j)
                    #on recupere le voisin le plus proche dans la direction nord
                    if((@tabCase[i].tabVoisins[0]==false && @tabCase[i].ligne>@tabCase[j].ligne && @tabCase[i].colonne==@tabCase[j].colonne) || ( @tabCase[i].ligne>@tabCase[j].ligne && @tabCase[i].colonne==@tabCase[j].colonne && @tabCase[j].ligne>@tabCase[i].tabVoisins[0].ligne ) )
                        @tabCase[i].tabVoisins[0]=@tabCase[j]
                        @tabCase[i].tabTriangle[0]=true
                    end
                    #on recupere le voisin le plus proche dans la direction Sud
                    if((@tabCase[i].tabVoisins[2]==false && @tabCase[i].ligne<@tabCase[j].ligne && @tabCase[i].colonne==@tabCase[j].colonne) || ( @tabCase[i].ligne<@tabCase[j].ligne && @tabCase[i].colonne==@tabCase[j].colonne && @tabCase[j].ligne<@tabCase[i].tabVoisins[2].ligne ) )
                        @tabCase[i].tabVoisins[2]=@tabCase[j]
                        @tabCase[i].tabTriangle[2]=true
                    end
                    #on recupere le voisin le plus proche dans la direction ouest
                    if((@tabCase[i].tabVoisins[3]==false && @tabCase[i].colonne>@tabCase[j].colonne && @tabCase[i].ligne==@tabCase[j].ligne) || ( @tabCase[i].colonne>@tabCase[j].colonne && @tabCase[i].ligne==@tabCase[j].ligne && @tabCase[j].colonne>@tabCase[i].tabVoisins[3].colonne ) )
                        @tabCase[i].tabVoisins[3]=@tabCase[j]
                        @tabCase[i].tabTriangle[3]=true
                    end
                    #on recupere le voisin le plus proche dans la direction est
                    if((@tabCase[i].tabVoisins[1]==false && @tabCase[i].colonne<@tabCase[j].colonne && @tabCase[i].ligne==@tabCase[j].ligne) || ( @tabCase[i].colonne<@tabCase[j].colonne && @tabCase[i].ligne==@tabCase[j].ligne && @tabCase[j].colonne<@tabCase[i].tabVoisins[1].colonne ) )
                        @tabCase[i].tabVoisins[1]=@tabCase[j]
                        @tabCase[i].tabTriangle[1]=true
                    end
                end
            end
        end
    end

    def Grille.creer(tab)
        new(tab)
    end

    def tabCaseAfficher()
        for i in 0..@tabCase.length-1
            puts(tabCase[i])
        end
    end

    def supprimerLien(ligne,colonne)
        tabC=Array.new(4,false)
        for j in 0..@tabCase.length-1 do
        #on enleve les tabCase[i].  , on remplace tabVoisins par tabC et on laisse les tabCase[j]
            #on recupere le voisin le plus proche dans la direction nord
            if((tabC[0]==false && ligne>@tabCase[j].ligne && colonne==@tabCase[j].colonne) || ( ligne>@tabCase[j].ligne && colonne==@tabCase[j].colonne && @tabCase[j].ligne>tabC[0].ligne ) )
                tabC[0]=@tabCase[j]
            end

            #on recupere le voisin le plus proche dans la direction Sud
            if((tabC[2]==false && ligne<@tabCase[j].ligne && colonne==@tabCase[j].colonne) || ( ligne<@tabCase[j].ligne && colonne==@tabCase[j].colonne && @tabCase[j].ligne<tabC[2].ligne ) )
                tabC[2]=@tabCase[j]
            end

            #on recupere le voisin le plus proche dans la direction ouest
            if((tabC[3]==false && colonne>@tabCase[j].colonne && ligne==@tabCase[j].ligne) || ( colonne>@tabCase[j].colonne && ligne==@tabCase[j].ligne && @tabCase[j].colonne>tabC[3].colonne ) )
                tabC[3]=@tabCase[j]
            end

            #on recupere le voisin le plus proche dans la direction est
            if((tabC[1]==false && colonne<@tabCase[j].colonne && ligne==@tabCase[j].ligne) || ( colonne<@tabCase[j].colonne && ligne==@tabCase[j].ligne && @tabCase[j].colonne<tabC[1].colonne ) )
                tabC[1]=@tabCase[j]
            end
        end
        for i in 0..1 do
            if(tabC[i]!=false&&tabC[i+2]!=false)
                for j in 0..@tabLien.length-1 do
                    if ((@tabLien[j]!=nil && @tabLien[j].case1.etiquetteCase ==tabC[i].etiquetteCase &&  @tabLien[j].case2.etiquetteCase ==tabC[i+2].etiquetteCase)||(@tabLien[j]!=nil && @tabLien[j].case2.etiquetteCase ==tabC[i+2].etiquetteCase &&  @tabLien[j].case2.etiquetteCase ==tabC[i].etiquetteCase))
                        x=Utilitaire.index(@tabCase,@tabLien[j].case1)
                        y=Utilitaire.index(@tabCase,@tabLien[j].case2)
                        @tabLien.delete_at(j)
                        if(@tabCase[x].ligne<@tabCase[y].ligne && @tabCase[x].colonne == @tabCase[y].colonne)
                            @tabCase[x].tabTriangle[2] = true
                            @tabCase[y].tabTriangle[0] = true
                        elsif(@tabCase[x].ligne>@tabCase[y].ligne && @tabCase[x].colonne == @tabCase[y].colonne)
                            @tabCase[x].tabTriangle[0] = true
                            @tabCase[y].tabTriangle[2] = true
                        elsif(@tabCase[x].ligne==@tabCase[y].ligne && @tabCase[x].colonne < @tabCase[y].colonne)
                            @tabCase[x].tabTriangle[1] = true
                            @tabCase[y].tabTriangle[3] = true
                        elsif(@tabCase[x].ligne==@tabCase[y].ligne && @tabCase[x].colonne > @tabCase[y].colonne)
                            @tabCase[x].tabTriangle[3] = true
                            @tabCase[y].tabTriangle[1] = true
                        end
                    end
                end
            end
        end
    end


    def contientCaseAvecEtiquette(ligne,colonne)
        for i in 0..@tabCase.length-1 do
            if(@tabCase[i].ligne==ligne && @tabCase[i].colonne==colonne)
                return @tabCase[i]
            end
        end
        return false
    end

    def clickCercle(ligne,colonne)#a modifier pour afficher toutes les cases reliées

        for i in 0..@tabCase.length-1 do
            if(@tabCase[i].ligne==ligne && @tabCase[i].colonne==colonne)
                break
            end
        end
        return @tabCase[i].tabVoisins

    end

    def clickTriangle(ligne,colonne,pos)
        for i in 0..@tabCase.length-1 do
            if(@tabCase[i].ligne==ligne && @tabCase[i].colonne==colonne)
                break
            end
        end
        @tabCase[i].creerLien(pos,@hypothese,@tabLien)
        
    end

    def clicLien(ligne, colonne)
        self.supprimerLien(ligne,colonne)
    end

    def commencerHypothese()
        @hypothese=true
    end


    def validerHypothese()
        for i in 0..@tabLien.length-1 do
            if(@tabLien[i].hypothese==true)
                @tabLien[i].hypothese=false
            end
        end
        @hypothese=false
    end

    def lienSimilaire(l)
        @tabLien.each do  |lien|
            if(l!=lien  && (lien.case1==l.case1 && lien.case2==l.case2) || (lien.case1==l.case2 && lien.case2==l.case1))
                return lien
            end
        end
        return nil
    end

    def annulerHypothese()
        for i in 0..@tabLien.length-1 do
            if(@tabLien[i].hypothese==true)
                ligne=((@tabLien[i].case1.ligne + @tabLien[i].case2.ligne)-( (@tabLien[i].case1.ligne + @tabLien[i].case2.ligne)%2 )   )/2
                colonne=((@tabLien[i].case1.colonne + @tabLien[i].case2.colonne)-( (@tabLien[i].case1.colonne + @tabLien[i].case2.colonne)%2 )   )/2
                self.supprimerLien(ligne,colonne)
            end
        end
        @hypothese=false
        
    end





end
