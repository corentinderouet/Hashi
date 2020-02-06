load "Lien.rb"

class Case

	attr_reader:posX
	attr_reader:posY
	attr_reader:etiquetteCase
	attr_accessor:tabVoisins
	attr_accessor:tabTriangle

	private_class_method:new

	def initialize(posX,posY,etiquetteCase)
		@posX=posX
		@posY=posY
		@etiquetteCase=etiquetteCase
		@tabTriangle=Array.new(4,false)
		@tabVoisins=Array.new(4,false)

	end

	def Case.creer(posX,posY,etiquetteCase)
		new(posX,posY,etiquetteCase)
	end
		
	def creer_lien(posTabTriangle,hypothese,tabLien)
		if(self.tabTriangle[posTabTriangle]!=false)
			l=Lien.creer(self,self.tabVoisins[posTabTriangle],hypothese)
			c=0
			tabLien.each do  |lien|
				#  puts('recherche si le lien existe')
				if((lien.case1.posX == self.posX && lien.case1.posY == self.posY) && (lien.case2.posX == self.tabVoisins[posTabTriangle].posX && lien.case2.posY == self.tabVoisins[posTabTriangle].posY ) )
					c +=1
					#puts('il existe un lien de self vers la direction')
				elsif ((lien.case2.posX == self.posX && lien.case2.posY == self.posY) && (lien.case1.posX == self.tabVoisins[posTabTriangle].posX && lien.case1.posY == self.tabVoisins[posTabTriangle].posY ))
					c +=1
					#puts('il existe un lien de ladirection vers self')
				end
			end
			if(c==1)
				self.tabTriangle[posTabTriangle] = false
				self.tabVoisins[posTabTriangle].tabTriangle[(posTabTriangle + 2)%4] = false
			end
			return l
		else
			#puts('impossible de creer un lien entre ' "#{@etiquetteCase}"' et ' "#{self.tabVoisins[posTabTriangle].etiquetteCase}"' deja existant')
		end
	end
end
