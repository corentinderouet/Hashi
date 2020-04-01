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

		if(difficulte=="Facile")
			fichierSource="../src/Grilles/grilles_site_ser_facile.txt"
		elsif(difficulte=="Moyen")
			fichierSource="../src/Grilles/grilles_site_ser_moyen.txt"
		elsif (difficulte=="Difficile")
			fichierSource="../src/Grilles/grilles_site_ser_difficile.txt"
		else
			fichierSource="../src/Grilles/grilles_site_ser.txt"
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
					#puts("  ")
					comptligne+=1
					comptcolonne=-1
				elsif(s=="D")
					#print("==")
				elsif(s=="H") 
					#print("--")
				elsif(s=="V") 
					#print("| ")
				elsif (s=="E") 
					#print("||")
				elsif (s=="_") 
					#print("  ")
				elsif(s=="$") 
					sortie=1
				else
					#print(s)
					c=Case.creer(comptligne,comptcolonne,s)
					tabCase.push(c)
					#print(" ")
				end	
			end	
			#print("\n\n\n")
			g = Grille.creer(tabCase, comptligne, comptligne, nil) #La grille étant carrée, comptligne représente la hauteur et la largeur
			fichier.close

			return g
		else
			puts("Id non trouvé")
		end
	end

	# Transformation des grilles sous format texte en format Grille
	# === Parametres
	# * +id+ => identifiant de la grille à charger
	# * +difficulte+ => caractère en fonction de la difficulté : m-> moyen / f-> facile / d-> difficile
	# === Retour 
	# retourne une grille qui a été créée
	def SerGrille.deserialiseVide(difficulte) 
		
		# Choix des fichiers à ouvrir 

		if(difficulte=="Facile")
			fichierSource="../src/Grilles/grilles_site_ser_facile.txt"
		elsif(difficulte=="Moyen")
			fichierSource="../src/Grilles/grilles_site_ser_moyen.txt"
		elsif (difficulte=="Difficile")
			fichierSource="../src/Grilles/grilles_site_ser_difficile.txt"
		else
			fichierSource="../src/Grilles/grilles_site_ser.txt"
		end

		fichier=File.open(fichierSource, "r")
		tabGrille=[]
		comptligne = 0
		comptcolonne = 0
		# Parcours n°1 pour créer les cases et la grille
		fichier.each_line do | ligne2 |
			tabCase=[]	
			ligne=ligne2.split("")
			ligne.pop
			#compteur pour savoir les coordonées de chaque case
			comptligne = 0
			comptcolonne = 0

			ligne.each do | s | 
				if(s==";") 
					comptligne += 1
					comptcolonne = -1
				elsif (s =~ /[[:digit:]]/)					
					tabCase.push(Case.creer(comptligne,comptcolonne,s))
				end
				comptcolonne+=1
			end	
			if( comptligne != 0)
				tabGrille.push( Grille.creer(tabCase, comptligne, comptligne, nil) ) #La grille étant carrée, comptligne représente la hauteur et la largeur
			end
#puts "ligne: #{ligne2}"
#                        tabCase.select { |c10| puts "#{c10.etiquetteCase} : #{c10.ligne} / #{c10.colonne}" }

		end
		indice = 0

		tabLienHTmp = Array.new(comptligne)
		# Parcours n°2 pour créer les liens
		fichier.rewind

		fichier.each_line do | ligne |
			grille = tabGrille[indice]
			comptligne = 0
			comptcolonne = 0

			tabLienVTmp = Array.new(comptligne)

			if grille != nil
#puts "ligne: #{ligne}"

				ligne.each_char do | s |
	
					if(s==";") 
						caseTmp = nil
						lien = nil
						# Création des liens horizontaux si nécessaire
						tabLienHTmp.each do | l |
#		puts "l class: #{l.class}"
							if (l.instance_of? Case)
#		puts "l est une case: #{l}"
								if (caseTmp == nil || lien == nil)
									caseTmp = l
#puts "nouvelle caseTmp: #{caseTmp}"
								else
#		puts "création lien horizontal: #{caseTmp.etiquetteCase}"
									grille.clicTriangle(caseTmp, 1)
			
									if (lien == false)
										grille.clicTriangle(caseTmp, 1)
									end
		
									caseTmp = l
									lien = nil
								end
							else
								lien = l
							end
						end
	

						comptligne += 1
						comptcolonne = -1
	
					# Si numéro ==> enregistre le chiffre dans la table horizontale tabLienHTmp, et crée un lien vertical si nécessaire
					elsif(s =~ /[[:digit:]]/)
						c = grille.tabCase.select { |c1| c1.ligne == comptligne && c1.colonne == comptcolonne }
#			puts "c dans grille: #{c1.ligne}/#{c1.colonne}; #{comptligne}/#{comptcolonne}"
#						end
	#					c = c.first
	
						tabLienHTmp[comptcolonne] = c.first
#	puts "c: #{c.first}"
	#p c
	
						# Création du lien vertical (vers le nord) si besoin
						if (tabLienVTmp[comptcolonne] != nil)
							begin
								grille.clicTriangle(tabLienHTmp[comptcolonne], 0)

								if (tabLienVTmp[comptcolonne] == false)
									grille.clicTriangle(tabLienHTmp[comptcolonne], 0)
								end

							rescue
								puts "Problème: lien vide en #{comptligne}/#{comptcolonne}" #	#{c.first.etiquetteCase}"
								puts "V = #{tabLienVTmp[comptcolonne]}"
								puts "H = #{tabLienHTmp[comptcolonne]}, est un #{s}"
								puts "pour #{ligne}"
#								grille.tabCase.select { |c10| puts "#{c10.etiquetteCase} : #{c10.ligne} / #{c10.colonne}" }
							end
	
							tabLienVTmp[comptcolonne] = nil
						end
	
					else
						if(s == "H")
							tabLienHTmp[comptcolonne] = true
						elsif(s == "D")
							tabLienHTmp[comptcolonne] = false
						elsif(s == "V")
							tabLienVTmp[comptcolonne] = true
						elsif(s == "E")
							tabLienVTmp[comptcolonne] = false
						elsif(s == "_")
							tabLienHTmp[comptcolonne] = nil
						end
					end
	
					comptcolonne+=1
				end	
	
				# Mise à jour de la grille
				tabGrille[indice] = grille
				indice += 1
#				puts "<SerGrille> Grille: #{indice}"
			end

		end
#puts "Fin SerGrille"
		fichier.close

		return tabGrille
	end
	# Transformation des grilles sous format texte prise sur internet en format texte avec notre convention d'écriture
	# === Parametres
	# * +difficulte+ => caractère en fonction de la difficulté pour savoir dans quel fichier aller: m-> moyen / f-> facile / d-> difficile
	# === Retour 
	# Aucun retour : création d'un fichier texte sous notre convention d'écriture.
	def SerGrille.transformeSerial(difficulte)
		
		# Choix des fichiers à ouvrir et supression des anciens fichiers
		if(difficulte=="Facile")then
			if (File.exist?("../src/Grilles/grilles_site_ser_facile.txt"))
				File.delete "../src/Grilles/grilles_site_ser_facile.txt"
			end
			fichierSource="../src/Grilles/grilles_site_facile.txt"
			fichierRecept="../src/Grilles/grilles_site_ser_facile.txt"
		elsif(difficulte=="Moyen")
			if (File.exist?("../src/Grilles/grilles_site_ser_moyen.txt"))
				File.delete "../src/Grilles/grilles_site_ser_moyen.txt"
			end
			fichierSource="../src/Grilles/grilles_site_moyen.txt"
			fichierRecept="../src/Grilles/grilles_site_ser_moyen.txt"
		elsif (difficulte=="Difficile")then
			if (File.exist?("../src/Grilles/grilles_site_ser_difficile.txt"))
				File.delete "../src/Grilles/grilles_site_ser_difficile.txt"
			end
			fichierSource="../src/Grilles/grilles_site_difficile.txt"
			fichierRecept="../src/Grilles/grilles_site_ser_difficile.txt"
		else
			if (File.exist?("../src/Grilles/grilles_site_ser.txt"))
				File.delete "../src/Grilles/grilles_site_ser.txt"
			end
			fichierSource="../src/Grilles/grilles_site.txt"
			fichierRecept="../src/Grilles/grilles_site_ser.txt"
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

# Transformation des grilles sous format texte prise sur internet en format texte avec notre convention d'écriture
	# === Parametres
	# * +difficulte+ => caractère en fonction de la difficulté pour savoir dans quel fichier aller: m-> moyen / f-> facile / d-> difficile
	# === Retour 
	# Aucun retour : création d'un fichier texte sous notre convention d'écriture.
	def SerGrille.transformeSerial2(difficulte)
		
		# Choix des fichiers à ouvrir et supression des anciens fichiers
		if(difficulte=="Facile")then
			if (File.exist?("../src/Grilles/grilles_site_ser_facile.txt"))
				File.delete "../src/Grilles/grilles_site_ser_facile.txt"
			end
			fichierSource="../src/Grilles/grilles_site_facile.txt"
			fichierRecept="../src/Grilles/grilles_site_ser_facile.txt"
		elsif(difficulte=="Moyen")
			if (File.exist?("../src/Grilles/grilles_site_ser_moyen.txt"))
				File.delete "../src/Grilles/grilles_site_ser_moyen.txt"
			end
			fichierSource="../src/Grilles/grilles_site_moyen.txt"
			fichierRecept="../src/Grilles/grilles_site_ser_moyen.txt"
		elsif (difficulte=="Difficile")then
			if (File.exist?("../src/Grilles/grilles_site_ser_difficile.txt"))
				File.delete "../src/Grilles/grilles_site_ser_difficile.txt"
			end
			fichierSource="../src/Grilles/grilles_site_difficile.txt"
			fichierRecept="../src/Grilles/grilles_site_ser_difficile.txt"
		else
			if (File.exist?("../src/Grilles/grilles_site_ser.txt"))
				File.delete "../src/Grilles/grilles_site_ser.txt"
			end
			fichierSource="../src/Grilles/grilles_site.txt"
			fichierRecept="../src/Grilles/grilles_site_ser.txt"
		end
		fichierLec=File.open(fichierSource, "r")
		fichierEcr=File.open(fichierRecept, "a+")
		fichierLec.each_line do | ligne |
#puts "dernier car: #{ligne[ligne.length - 1] == "\n"}"
			taille= ligne[ligne.length - 1] == "\n" ? ligne.length - 1 : ligne.length
			tailleLigne=Math.sqrt(taille)

#puts "taille: #{taille}, tailleLigne: #{tailleLigne}"
			comptLigne=0
			ligne=ligne.split("")
#			ligne.pop
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
				elsif(car != "\n")
					fichierEcr.write(car)
#else
#puts "\\n ? #{car}"
				end

				if((comptLigne % tailleLigne) == 0)
					fichierEcr.write(";")
				end
			end
			fichierEcr.write("\n")
		end
end

