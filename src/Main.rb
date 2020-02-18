require_relative "Grille"

class Main
    private_class_method:new

    def Main.creer()
        new()
    end

    def initialize()
        nbligne=10
        nbcolonne=7
        tabGrille2=[[3,"H",1,"_",2,"H",2],["E","_","_","_","V","_","V"],[5,"D",3,"H",4,"_",1],["V",3,"H",1,"E","_","_"],[2,"E",4,"D",8,"D",2],["V",4,"E",2,"E","_","_"],["V","E",3,"E",4,"H",2],[1,"E","V",3,"V","_","V"],["_","E",1,"V",1,"_","V"],["_",4,"D",4,"H","H",2],]
        puts("Fin de complétion du tableau 2")
        SerGrille.serialise(tabGrille2,nbligne,nbcolonne,9)

        

        g= Grille.creer(SerGrille.deserialise(9,"k").tabCase)


        puts "Affichage GRILLE"
        for i in 0..nbligne-1 do
            print ""
            for j in 0..nbcolonne-1 do
                val=g.contientCaseAvecEtiquette(i,j)
                if(val!=false)
                    print ("|#{val.etiquetteCase}")
                else
                    print "| "
                end
            end
            puts "|"
        end



    end

end


main=Main.creer()
