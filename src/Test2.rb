load "SerGrille.rb"
load'Grille.rb'
#Test
puts("Début Test")
nbligne=6
nbcolonne=7
tabGrille = Array.new(nbligne) { Array.new(nbcolonne) { "_" } }
tabGrille[0][0]=2
tabGrille[0][1]="H"
tabGrille[0][2]="H"
tabGrille[0][3]="H"
tabGrille[0][4]=3
tabGrille[0][5]="D"
tabGrille[0][6]=3
tabGrille[1][0]="V"
tabGrille[1][1]=1
tabGrille[1][2]="H"
tabGrille[1][3]=4
tabGrille[1][4]="D"
tabGrille[1][5]=4
tabGrille[1][6]="V"
tabGrille[2][0]="V"
tabGrille[2][3]="V"
tabGrille[2][5]="E"
tabGrille[2][6]="V"
tabGrille[3][0]=3
tabGrille[3][1]="H"
tabGrille[3][2]="H"
tabGrille[3][3]=3
tabGrille[3][5]=2
tabGrille[3][6]="V"
tabGrille[4][0]="V"
tabGrille[4][3]="V"
tabGrille[4][4]=1
tabGrille[4][5]="H"
tabGrille[4][6]=2
tabGrille[5][0]=2
tabGrille[5][1]="H"
tabGrille[5][2]="H"
tabGrille[5][3]=4
tabGrille[5][4]="D"
tabGrille[5][5]=2
puts("Fin de complétion du tableau 1")
SerGrille.serialise(tabGrille,nbligne,nbcolonne,5)

nbligne=10
nbcolonne=7
tabGrille = Array.new(nbligne) { Array.new(nbcolonne) { "_" } }
tabGrille[0][0]=1
tabGrille[0][2]=3
tabGrille[0][3]="H"
tabGrille[0][4]="H"
tabGrille[0][5]=3
tabGrille[1][0]="V"
tabGrille[1][2]="E"
tabGrille[1][5]="E"
tabGrille[2][0]=4
tabGrille[2][1]="D"
tabGrille[2][2]=8
tabGrille[2][3]="D"
tabGrille[2][4]=4
tabGrille[2][5]="E"
tabGrille[2][6]=1
tabGrille[3][0]="V"
tabGrille[3][1]=1
tabGrille[3][2]="E"
tabGrille[3][4]="E"
tabGrille[3][5]=2
tabGrille[3][6]="V"
tabGrille[4][0]=3
tabGrille[4][1]="V"
tabGrille[4][2]=2
tabGrille[4][4]=5
tabGrille[4][5]="H"
tabGrille[4][6]=2
tabGrille[5][0]="E"
tabGrille[5][1]="V"
tabGrille[5][4]="E"
tabGrille[6][0]="E"
tabGrille[6][1]=2
tabGrille[6][2]="H"
tabGrille[6][3]="H"
tabGrille[6][4]=4
tabGrille[6][5]="H"
tabGrille[6][6]=3
tabGrille[7][0]=6
tabGrille[7][1]="D"
tabGrille[7][2]=5
tabGrille[7][3]="D"
tabGrille[7][4]="D"
tabGrille[7][5]=2
tabGrille[7][6]="E"
tabGrille[8][0]="E"
tabGrille[8][2]="V"
tabGrille[8][3]=1
tabGrille[8][4]="H"
tabGrille[8][5]="H"
tabGrille[8][6]=3
tabGrille[9][0]=2
tabGrille[9][2]=2
tabGrille[9][3]="H"
tabGrille[9][4]=1
puts("Fin de complétion du tableau 2")
SerGrille.serialise(tabGrille,nbligne,nbcolonne,7)

nbligne=10
nbcolonne=7
tabGrille2=[[3,"H",1,"_",2,"H",2],["E","_","_","_","V","_","V"],[5,"D",3,"H",4,"_",1],["V",3,"H",1,"E","_","_"],[2,"E",4,"D",8,"D",2],["V",4,"E",2,"E","_","_"],["V","E",3,"E",4,"H",2],[1,"E","V",3,"V","_","V"],["_","E",1,"V",1,"_","V"],["_",4,"D",4,"H","H",2],]
puts("Fin de complétion du tableau 2")
SerGrille.serialise(tabGrille2,nbligne,nbcolonne,9)

puts("Affichage simple de la grille 2")
g2=SerGrille.deserialise(7)

puts("Affichage simple de la grille 3")
g3=SerGrille.deserialise(9)

puts("Affichage simple de la grille 1")
g1=SerGrille.deserialise(12)


ligne=10
colonne=7
for i in 0..ligne-1 do
    print ""
    for j in 0..colonne-1 do
        val=g3.contientCaseAvecEtiquette(i,j)
        if(val!=false)
            print ("|#{val.etiquetteCase}")
        else
            print "| "
        end
    end
    puts "|"
end