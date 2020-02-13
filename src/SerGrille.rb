class SerGrille
	def SerGrille.serialise(tabGrille,nb_lignes,nb_colonnes,id)
		verifId=1
		fichier=File.open("grilles_serialisées.txt", "a")
		fichier.close
		fichier=File.open("grilles_serialisées.txt", "r")
		if(!(fichier.eof)) then
			s=fichier.readchar()
			g=s
			while(s!=":")do
				s=fichier.readchar()
				if(s!=":")then
					g+=s
				end
			end
			if(g==id.to_s) then
				verifId= 0
			end
		end
		while(!(fichier.eof))do
			s=fichier.readchar()
			if(!(fichier.eof)) then
			 	if(s=="$")then
					s=fichier.readchar()
					g=s
					while(s!=":")do
						s=fichier.readchar()
						if(s!=":")then
							g+=s
						end
					end
			 		if(g==id.to_s) then
			 			verifId= 0
			 		end
			 	end
			end
		end
		fichier.close

		if(verifId==1) then
			fichier=File.open("grilles_serialisées.txt", "a")
			fichier.write(id)
			fichier.write(":")
			# fichier.write(nb_lignes)
			# fichier.write(";")
			# fichier.write(nb_colonnes)
			# fichier.write(";")
			for i in 0..nb_lignes-1 do
				for j in 0..nb_colonnes-1 do
					fichier.write(tabGrille[i][j])
				end
				fichier.write(";")	
			end
			fichier.write("$")
			fichier.close
		else
			puts("Id déjà existant")
		end
	end

	def SerGrille.deserialise(id)
		tabCase=[]
		fichier=File.open("grilles_serialisées.txt", "r")
		#compteur pour savoir les coordonées de chaque case
		comptligne=0
		comptcolonne=-1
		#Placement de la lecture à la grille choisie
		verifId=1
		if(!(fichier.eof)) then
			s=fichier.readchar()
			g=s
			while(s!=":")do
				s=fichier.readchar()
				if(s!=":")then
					g+=s
				end
			end
			if(g==id.to_s) then
				verifId= 0
			end
		end
		while(!(fichier.eof))do
			s=fichier.readchar()
			if(!(fichier.eof)) then
			 	if(s=="$")then
					s=fichier.readchar()
					g=s
					while(s!=":")do
						s=fichier.readchar()
						if(s!=":")then
							g+=s
						end
					end
			 		if(g==id.to_s) then
			 			verifId= 0
			 		end
			 	end
			end
		end
		fichier.close
		placementLecture=0
		fichier=File.open("grilles_serialisées.txt", "r")
		if(verifId==0) then
			s=fichier.readchar()
			g=s
			while(s!=":")do
				s=fichier.readchar()
				if(s!=":")then
					g+=s
				end
			end
			if(g==id.to_s)then
				placementLecture=1
			end
			while(placementLecture==0)do
				s=fichier.readchar()
				if(s=="$")then
					s=fichier.readchar()
					g=s
					while(s!=":")do
						s=fichier.readchar()
						if(s!=":")then
							g+=s
						end
					end
					if(g==id.to_s)then
						placementLecture=1
					end
				end
			end
			#skip la taille dans l'affichage
			# evittaille=0
			# while(evittaille!=2)do
			# 	s=fichier.readchar()
			# 	if(s==";")then
			# 		evittaille+=1
			# 	end
			# end
			#affichage primaire de la grille après désériaisation + création du tableau de case
			sortie=0
			while sortie==0 do
				s=fichier.readchar()
				comptcolonne+=1
				if(s==";") 
					puts("  ")
					comptligne+=1
					comptcolonne=-1
				elsif(s=="D")
					print("==")
				elsif(s=="H") 
					print("--")
				elsif(s=="V") 
					print("| ")
				elsif (s=="E") 
					print("||")
				elsif (s=="_") 
					print("  ")
				elsif(s=="$") 
					sortie=1
				else
					print(s)
					c=Case.creer(comptligne,comptcolonne,s)
					tabCase.push(c)
					print(" ")
				end	
			end	
			print("\n\n\n")
			g=Grille.creer(tabCase,nb_lignes,nb_colonnes)
			fichier.close

			return g
		else
			puts("Id non trouvé")
		end
	end

	def transformeSerial
		
		fichierLec=File.open("grilles_site.txt", "r")
		fichierEcr=File.open("grilles_site_ser.txt","a")
		#compteur pour savoir les coordonées de chaque case
		id=1
		fichierLec.each_line do | ligne |
			fichierEcr.write(id)
			fichierEcr.write(":")
			taille=ligne.length - 1
			tailleLigne=Math.sqrt(taille)
			comptLigne=0
			ligne=ligne.split('')
			ligne.pop
			ligne.each do | car |
				comptLigne+=1
				if(car==" ")
					fichierEcr.write("_")
				elsif(car=="a")
					fichierEcr.write("H")
				elsif(car=="b")
					fichierEcr.write("D")
				elsif(car=="c")
					fichierEcr.write("V")
				elsif(car=="d")
					fichierEcr.write("E")
				else
					fichierEcr.write(car)
				end

				if((comptLigne % tailleLigne) == 0)
					fichierEcr.write(";")
				end
			end
			fichierEcr.write("$")
			id+=1
		end
	end
end
