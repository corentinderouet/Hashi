load'Case.rb'
class Grille
	attr_accessor:tabCase
	attr_accessor:tabLien

	# =>    posX=0  posX=1  posX=2
	#posY=0 (0,0)   (0,1)   (0,2)
	#posY=1 (1,0)   (1,1)   (1,2)
	#posY=2 (2,0)   (2,1)   (2,2)
	def initialize(tab)
		@tabCase=[]
		@tabLien=Array.new()

		@tabCase+=tab
		#tabCase.push(c2)
		#tabCase.push(c3)
=begin
		for i in 0..@tabCase.length-1 do
			for j in 0..@tabCase.length-1 do
				if(i !=j)
					#on recupere le voisin le plus proche dans la direction nord
					if((@tabCase[i].tabVoisins[0]==false && @tabCase[i].posY>@tabCase[j].posY && @tabCase[i].posX==@tabCase[j].posX) || ( @tabCase[i].posY>@tabCase[j].posY && @tabCase[i].posX==@tabCase[j].posX && @tabCase[j].posY>@tabCase[i].tabVoisins[0] ) )
						@tabCase[i].tabVoisins[0]=@tabCase[j]
						@tabCase[i].tabTriangle[0]=true
					end
					#on recupere le voisin le plus proche dans la direction Sud
					if((@tabCase[i].tabVoisins[2]==false && @tabCase[i].posY<@tabCase[j].posY && @tabCase[i].posX==@tabCase[j].posX) || ( @tabCase[i].posY<@tabCase[j].posY && @tabCase[i].posX==@tabCase[j].posX && @tabCase[j].posY<@tabCase[i].tabVoisins[2] ) )
						@tabCase[i].tabVoisins[2]=@tabCase[j]
						@tabCase[i].tabTriangle[2]=true
					end
					#on recupere le voisin le plus proche dans la direction ouest
					if((@tabCase[i].tabVoisins[3]==false && @tabCase[i].posX>@tabCase[j].posX && @tabCase[i].posY==@tabCase[j].posY) || ( @tabCase[i].posX>@tabCase[j].posX && @tabCase[i].posY==@tabCase[j].posY && @tabCase[j].posX>@tabCase[i].tabVoisins[3] ) )
						@tabCase[i].tabVoisins[3]=@tabCase[j]
						@tabCase[i].tabTriangle[3]=true
					end
					#on recupere le voisin le plus proche dans la direction est
					if((@tabCase[i].tabVoisins[1]==false && @tabCase[i].posX<@tabCase[j].posX && @tabCase[i].posY==@tabCase[j].posY) || ( @tabCase[i].posX<@tabCase[j].posX && @tabCase[i].posY==@tabCase[j].posY && @tabCase[j].posX<@tabCase[i].tabVoisins[1] ) )
						@tabCase[i].tabVoisins[1]=@tabCase[j]
						@tabCase[i].tabTriangle[1]=true
					end
				end
			end
		end
=end
	end

	def Grille.creer(tab)
		new(tab)
	end

	def tabCase_afficher()
		for i in 0..@tabCase.length-1
			puts(tabCase[i])
		end
	end

	def supprimerLien(posX,posY)
		c=0
		for i in  0..@tabCase.length-1 do
			if(@tabCase[i].posX==posX || @tabCase[i].posY==posY)
				c=@tabCase[i]
			end
		end
		if(c!=0)
			for i in 0..@tabLien.length-1 do
				if(@tabLien[i].case1 == c ||@tabLien[i].case2 == c)
					@tabLien.delete_at(i)
					break
				end
			end
		end
	end
end


c1= Case.creer(0,0,1)
c2= Case.creer(2,0,3)
c3= Case.creer(2,2,2)
tab=[]
tab.push(c1)
tab.push(c2)
tab.push(c3)
g= Grille.creer(tab)

g.tabLien.push(g.tabCase[0].creer_lien(1,false,g.tabLien))
g.tabLien.push(g.tabCase[1].creer_lien(3,false,g.tabLien))
g.tabLien.push(g.tabCase[1].creer_lien(2,false,g.tabLien))
g.tabLien.push(g.tabCase[0].creer_lien(1,true,g.tabLien))
#g.supprimerLien(1,0)
g.tabLien.push(g.tabCase[0].creer_lien(1,true,g.tabLien))
for i in 0..2 do
	#g.tabLien[i].afficher_lien()
end
