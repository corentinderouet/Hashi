
# Permet d'interagir avec les fichiers texte
class SerGrille

	#Passage en écriture texte d'une grille de source tableau -> Sûrement pas utile
	 # === Parametres
	 # * +tabGrille+ => tableau de réprésentation de grille
	 # * +nb_lignes+ => nb de lignes de la grille à créer
	 # * +nb_colonnes+ => nb de colonne de la grille à créer
	 # * +id+ => identifiant de la grille à créer
	 # === Retour 
	 # Aucun retour : Création d'un fichier si inexistant sinon ajout de la grille
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


	# Transformation des grilles sous format texte en format Grille
	# === Parametres
	# * +id+ => identifiant de la grille à charger
	# * +difficulte+ => caractère en fonction de la difficulté : m-> moyen / f-> facile / d-> difficile
	# === Retour 
	# retourne une grille qui a été créée
	def SerGrille.deserialise(id, difficulte)
		
		# Choix des fichiers à ouvrir 

		if(difficulte=="f")
			fichierSource="grilles_site_ser_facile.txt"
		elsif(difficulte=="m")
			fichierSource="grilles_site_ser_moyen.txt"
		elsif (difficulte=="d")
			fichierSource="grilles_site_ser_difficile.txt"
		else
			fichierSource="grilles_site_ser.txt"
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
			#skip la taille dans l'affichage ==> ( taille supprimée )

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
			g=Grille.creer(tabCase,comptligne,comptcolonne)
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
	def transformeSerial(difficulte)		
		# Choix des fichiers à ouvrir et supression des anciens fichiers
		if(difficulte=="f")then
			if (File.exist?("grilles_site_ser_facile.txt"))
				File.delete "grilles_site_ser_facile.txt"
			end
			fichierSource="grilles_site_facile.txt"
			fichierRecept="grilles_site_ser_facile.txt"
		elsif(difficulte=="m")
			if (File.exist?("grilles_site_ser_moyen.txt"))
				File.delete "grilles_site_ser_moyen.txt"
			end
			fichierSource="grilles_site_moyen.txt"
			fichierRecept="grilles_site_ser_moyen.txt"
		elsif (difficulte=="d")then
			if (File.exist?("grilles_site_ser_difficile.txt"))
				File.delete "grilles_site_ser_difficile.txt"
			end
			fichierSource="grilles_site_difficile.txt"
			fichierRecept="grilles_site_ser_difficile.txt"
		else
			fichierSource="grilles_site.txt"
			fichierRecept="grilles_site_ser.txt"
		end
			
		fichierLec=File.open(fichierSource, "r")
		fichierEcr=File.open(fichierRecept,"a")
		#numérotation automatique des grilles avec id
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
