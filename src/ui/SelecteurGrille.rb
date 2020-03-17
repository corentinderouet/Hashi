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

        grid = Gtk::Grid.new()
        grid.row_spacing = 40
        grid.column_spacing = 40
        grid.margin = 20

        3.times() do |x|
            10.times do |y|
                n = x+y*3+1
                vBox = Gtk::Box.new(Gtk::Orientation.new(1), 0)
                res=SerGrille.deserialise(n, dif)
                g = Grille.creer(res.tabCase,res.hauteur,res.largeur, nil)
                f = Gtk::Frame.new()
                a = AfficheurGrille.new(g, false)
                a.set_size_request(1,300)
                a.expand = true
                f.add(a)
                vBox.add(f)
                vBox.add(Gtk::Label.new("Grille n°#{n}"))
                vBox.signal_connect("button-press-event") { self.onClick(n, dif) }
                grid.attach(vBox, x, y, 1, 1)
            end
        end

        self.add(grid)
    end

    # Methodé appellée lors d'un clic sur une grille
    def onClick(n, dif)
        res = SerGrille.deserialise(n, dif)
        g = Grille.creer(res.tabCase,res.hauteur,res.largeur, nil)
        @fenetre.finSelection(g)
    end 
end
