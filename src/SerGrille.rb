
# Permet d'interagir avec les fichiers texte
class SerGrille
	# Transformation des grilles sous format texte en format Grille
	# === Parametres
	# * +id+ => identifiant de la grille à charger
	# * +difficulte+ => caractère en fonction de la difficulté : m-> moyen / f-> facile / d-> difficile
	# === Retour 
	# retourne une grille qui a été créée
	def SerGrille.deserialise(id, difficulte) 
		
		# Choix des fichiers à ouvrir 

		if(difficulte=="f")
			fichierSource="./Grilles/grilles_site_ser_facile.txt"
		elsif(difficulte=="m")
			fichierSource="./Grilles/grilles_site_ser_moyen.txt"
		elsif (difficulte=="d")
			fichierSource="./Grilles/grilles_site_ser_difficile.txt"
		else
			fichierSource="./Grilles/grilles_site_ser.txt"
		end

		tabCase=[]
		fichier=File.open(fichierSource, "r")
		#compteur pour savoir les coordonées de chaque case
		comptligne=0
		comptcolonne=-1
		verifId=1
		#Verification de la presence de l'Id en début de fichier
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
		#Verification de la présence de l'Id dans le reste du fichier
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
		#Placement de la lecture à la grille choisie
		fichier=File.open(fichierSource, "r")
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
			g=Grille.creer(tabCase,comptligne,comptligne,nil) #La grille étant carrée, comptligne représente la hauteur et la largeur
			fichier.close

			return g
		else
			puts("Id non trouvé")
		end
	end

	# Transformation des grilles sous format texte prise sur internet en format texte avec notre convention d'écriture
	# === Parametres
	# * +difficulte+ => caractère en fonction de la difficulté pour savoir dans quel fichier aller: m-> moyen / f-> facile / d-> difficile
	# === Retour 
	# Aucun retour : création d'un fichier texte sous notre convention d'écriture.
	def SerGrille.transformeSerial(difficulte)
		
		# Choix des fichiers à ouvrir et supression des anciens fichiers
		if(difficulte=="f")then
			if (File.exist?("./Grilles/grilles_site_ser_facile.txt"))
				File.delete "./Grilles/grilles_site_ser_facile.txt"
			end
			fichierSource="./Grilles/grilles_site_facile.txt"
			fichierRecept="./Grilles/grilles_site_ser_facile.txt"
		elsif(difficulte=="m")
			if (File.exist?("./Grilles/grilles_site_ser_moyen.txt"))
				File.delete "./Grilles/grilles_site_ser_moyen.txt"
			end
			fichierSource="./Grilles/grilles_site_moyen.txt"
			fichierRecept="./Grilles/grilles_site_ser_moyen.txt"
		elsif (difficulte=="d")then
			if (File.exist?("./Grilles/grilles_site_ser_difficile.txt"))
				File.delete "./Grilles/grilles_site_ser_difficile.txt"
			end
			fichierSource="./Grilles/grilles_site_difficile.txt"
			fichierRecept="./Grilles/grilles_site_ser_difficile.txt"
		else
			if (File.exist?("./Grilles/grilles_site_ser.txt"))
				File.delete "./Grilles/grilles_site_ser.txt"
			end
			fichierSource="./Grilles/grilles_site.txt"
			fichierRecept="./Grilles/grilles_site_ser.txt"
		end
		fichierLec=File.open(fichierSource, "r")
		fichierEcr=File.open(fichierRecept, "a+")
		id=1
		fichierLec.each_line do | ligne |
			fichierEcr.write(id)
			fichierEcr.write(":")
			taille=ligne.length - 1
			tailleLigne=Math.sqrt(taille)
			comptLigne=0
			ligne=ligne.split("")
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
