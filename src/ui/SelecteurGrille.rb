require "gtk3"

require_relative "AfficheurGrille"
require_relative "../Grille"
require_relative "../Case"
require_relative "../Lien"

# Widget Gtk permettant d'afficher un selecteur pour une grille
class SelecteurGrille < Gtk::ScrolledWindow

    # Constructeur
    #
    # === Paramètres
    #
    # * +fenetre+ - Fenetre principale
    # * +dif+ - Difficulté à utiliser
    def initialize(fenetre, dif)
        super()
        self.set_policy(Gtk::PolicyType::NEVER, Gtk::PolicyType::AUTOMATIC)
        self.expand = true
        @fenetre = fenetre

	#à modifier
	idMode = 1 # Entrainement
        grilles = [GestionBase.recupGrilles(fenetre.joueur.id, dif, 1, 0, 5),
                   GestionBase.recupGrilles(fenetre.joueur.id, dif, 1, 10, 5),
                   GestionBase.recupGrilles(fenetre.joueur.id, dif, 1, 20, 5)].inject(:+)
        #grilles = grilles.map() { |x| YAML.load(x.grilleSolution).grilleRes }

        grid = Gtk::Grid.new()
        grid.row_spacing = 40
        grid.column_spacing = 40
        grid.margin = 20
        
        x = 0
        y = 0

        grilles.each() do |g|
            vBox = Gtk::Box.new(Gtk::Orientation.new(1), 0)
            f = Gtk::Frame.new()
            a = AfficheurGrille.new(YAML.load(g.grilleSolution), false, nil)
            a.set_size_request(1,300)
            a.expand = true
            f.add(a)
            vBox.add(f)
            vBox.add(Gtk::Label.new("Grille n°#{x+y*3+1}"))
            vBox.signal_connect("button-press-event") { @fenetre.finSelection(g, "entrainement") }
            grid.attach(vBox, x, y, 1, 1)
            x += 1
            if x > 2
                x = 0
                y += 1
            end
        end

        self.add(grid)
    end
end
