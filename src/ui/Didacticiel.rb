require "gtk3"

# Fenetre comportant les règles du jeu, les techniques basiques
# et des explications sur l'interface
class Didacticiel < Gtk::Window

    # Constructeur
    def initialize()
        super("Didacticiel")
        self.set_default_size(700, 700)
        self.signal_connect('destroy') { self.close() }
        
        vbox = Gtk::Box.new(Gtk::Orientation.new(1), 0)

        vbox.margin = 15

        view = Gtk::TextView.new()
        view.wrap_mode = :word
        view1 = Gtk::TextView.new()
        view1.wrap_mode = :word
        view2 = Gtk::TextView.new()
        view2.wrap_mode = :word
        view3 = Gtk::TextView.new()
        view3.wrap_mode = :word
        view4 = Gtk::TextView.new()
        view4.wrap_mode = :word
        view5 = Gtk::TextView.new()
        view5.wrap_mode = :word
        view6 = Gtk::TextView.new()
        view6.wrap_mode = :word
        view7 = Gtk::TextView.new()
        view7.wrap_mode = :word
        view8 = Gtk::TextView.new()
        view8.wrap_mode = :word
        view.buffer.text = 
"   
    Règles : 

        Tout pont débute et finit sur une case.
        Aucun pont ne peut en croiser un autre.
        Tous les ponts sont en ligne droite.
        Le nombre de ponts qui passent sur une case est le nombre indiqué sur la dite case.
        Toutes les cases doivent être reliées entre elles.
        Le nombre de ponts en direction de chaque case ne peut pas être supérieur à 2.

    Techniques :

        Une case 1 ayant un seul voisin doit forcément être reliée à ce voisin avec un pont. 
"
        
        view1.buffer.text = 
"        
        Une case 2 ayant un seul voisin doit forcément relier 2 ponts à ce voisin. 
"
        
        view2.buffer.text = 
"        
        Une case 3 ayant exactement 2 voisins doit avoir au moins un pont relié vers chaque (car s'il y avait 2 ponts vers un des voisin, il resterait un dernier pont à faire vers le second voisin).
"
        
        view3.buffer.text = 
"         
        Une case 4 ayant exactement 2 voisins doit forcément relier 2 ponts à chaque voisin (car la limite de pont vers un voisin est de 2 et il y a 2 voisins, ce qui fait 4 ponts au total). 
"
        
        view4.buffer.text = 
"        
        Une case 5 ayant exactement 3 voisins doit avoir au moins un pont relié vers chaque voisin (car s'il devait y avoir 2 ponts vers 2 voisins, il resterait un dernier pont à relier au dernier voisin). 
"
        
        view5.buffer.text = 
"        
        Une case 6 ayant exactement 3 voisins doit forcément relier 2 ponts à chaque voisin (car la limite de pont vers un voisin est de 2 et il y a 3 voisins, ce qui fait 6 ponts au total) 
"
        
        view6.buffer.text = 
"        
        Une case 7 ayant exactement 4 voisins doit avoir au moins un pont relié vers chaque voisin (car s'il devait y avoir 2 ponts vers 3 voisins, il resterait un dernier pont à relier au dernier voisin). 
"
        
        view7.buffer.text = 
"        
        Une case 8 ayant exactement 4 voisins doit forcément relier 2 ponts à chaque voisin (car la limite de pont vers un voisin est de 2 et il y a 4 voisins, ce qui fait 8 ponts au total)
"
        
        view8.buffer.text = 
"        
    Interface :

        Les boutons : 
            Annuler : Permet de revenir un coup en arrière.
            Refaire : Permet de rétablir le dernier coup annulé.
            Vérification : Permet de revenir au dernier état de jeu sans erreur. Cependant, votre score en sera pénalisé en mode Classé et Aventure.
            Hypothèse : Permet d'émettre des hypothèses de liens. Ces liens seront d'une couleur différente pour vous signifier que vous entrez dans ce mode. À la fin de votre hypothèse, vous aurez
le choix de la valider, ou bien de l'annuler afin de revenir à l'état du jeu avant l'hypothèse. 
            Réinitialiser : Supprime tous les liens dans la grille.
            Position : Met une case en surbrillance (vert) où une technique connue est applicable. 
            Technique : Affiche dans la zone de texte une technique applicable sur l'une des cases de la grille, sans signifier laquelle.

        Les clics sur : 
            Triangle : Crée un lien vers la case voisine dans la direction du triangle.
            Case : Met en évidence (en rouge) tous les liens de l'île à laquelle appartient cette case.
            Lien : Supprime ce lien.
"
        view.sensitive = false
        view1.sensitive = false
        view2.sensitive = false
        view3.sensitive = false
        view4.sensitive = false
        view5.sensitive = false
        view6.sensitive = false
        view7.sensitive = false
        view8.sensitive = false
        scroll = Gtk::ScrolledWindow.new()
        image1 = Gtk::Image.new(:file => "../assets/didacticiel/1.jpg")
        image2 = Gtk::Image.new(:file => "../assets/didacticiel/2.jpg")
        image3 = Gtk::Image.new(:file => "../assets/didacticiel/3.jpg")
        image4 = Gtk::Image.new(:file => "../assets/didacticiel/4.jpg")
        image5 = Gtk::Image.new(:file => "../assets/didacticiel/5.jpg")
        image6 = Gtk::Image.new(:file => "../assets/didacticiel/6.jpg")
        image7 = Gtk::Image.new(:file => "../assets/didacticiel/7.jpg")
        image8 = Gtk::Image.new(:file => "../assets/didacticiel/8.jpg")
        

        vbox2 = Gtk::Box.new(Gtk::Orientation.new(1), 0)

        
        vbox2.add(view)
        vbox2.add(image1)

        vbox2.add(view1)
        vbox2.add(image2)
        
        vbox2.add(view2)
        vbox2.add(image3)
        
        vbox2.add(view3)
        vbox2.add(image4)
        
        vbox2.add(view4)
        vbox2.add(image5)
        
        vbox2.add(view5)
        vbox2.add(image6)

        vbox2.add(view6)
        vbox2.add(image7)

        vbox2.add(view7)
        vbox2.add(image8)

        vbox2.add(view8)
        
        scroll.add(vbox2)
        scroll.set_policy(:never, :automatic)
        scroll.vexpand = true
        
        bouton = Gtk::Button.new(label: "Quitter")
        bouton.signal_connect("clicked") { self.close() }
        bouton.margin_top = 10

        vbox.add(scroll)
        vbox.add(bouton)

        self.add(vbox)

        self.show_all()
    end
end
