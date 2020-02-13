load "Case.rb"
load "Lien.rb"

#Test
puts('a')
c1= Case.creer(0,0,1)
c2= Case.creer(0,2,3)
c3= Case.creer(3,3,2)

c1.tabVoisins[1] = c2
c2.tabVoisins[2]=c3
c2.tabVoisins[3]=c1
c3.tabVoisins[0]=c2

c1.tabTriangle[1]=true
c2.tabTriangle[2]=true
c2.tabTriangle[3]=true
c3.tabTriangle[0]=true

tabLien=[]
tabLien.push(c1.creer_lien(1,false,tabLien))
tabLien.push(c2.creer_lien(3,false,tabLien))
tabLien.push(c2.creer_lien(2,false,tabLien))
tabLien.push(c1.creer_lien(1,true,tabLien))
