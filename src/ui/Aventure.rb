require "gtk3"

require_relative "Monde"
require_relative "Europe"
require_relative "Afrique"
require_relative "Asie"
require_relative "Oceanie"
require_relative "AmeriqueNord"
require_relative "AmeriqueSud"
require_relative "Antarctique"

# Widget Gtk permettant d'afficher l'aventure
class Aventure < Gtk::Overlay

    attr_reader :grillesF, :grillesM, :grillesD

    attr_accessor :nbEtoiles

    attr_accessor :etoiles

    # Constructeur
    #
    # === Paramètres
    #
    # * +fenetre+ - Fenetre principale
    def initialize(fenetre)
        super()
        @stack = Gtk::Stack.new()
        @stack.set_transition_type(Gtk::Stack::TransitionType::CROSSFADE)
        @stack.set_transition_duration(500)
        @fenetre = fenetre
        
        @grillesF = GestionBase.recupGrilles(fenetre.joueur.id, 1, 3, 0, 14)
        #@grillesF = @grillesF.map() { |x| YAML.load(x.grilleSolution) }
        @grillesM = GestionBase.recupGrilles(fenetre.joueur.id, 2, 3, 0, 14)
        #@grillesM = @grillesM.map() { |x| YAML.load(x.grilleSolution) }
        @grillesD = GestionBase.recupGrilles(fenetre.joueur.id, 3, 3, 0, 15)
        #@grillesD = @grillesD.map() { |x| YAML.load(x.grilleSolution) }
        
        self.calculNbEtoiles()

        @monde = Monde.new(self)
        @europe = Europe.new(self)
        @afrique = Afrique.new(self)
        @asie = Asie.new(self)
        @oceanie = Oceanie.new(self)
        @ameriqueNord = AmeriqueNord.new(self)
        @ameriqueSud = AmeriqueSud.new(self)
        @antarctique = Antarctique.new(self)
        @stack.add_named(@monde, "monde")
        @stack.add_named(@europe, "europe")
        @stack.add_named(@afrique, "afrique")
        @stack.add_named(@asie, "asie")
        @stack.add_named(@oceanie, "oceanie")
        @stack.add_named(@ameriqueNord, "ameriqueNord")
        @stack.add_named(@ameriqueSud, "ameriqueSud")
        @stack.add_named(@antarctique, "antarctique")
        @dernier = @stack.visible_child_name()

        @stack.halign = :start
        @stack.valign = :start
        @stack.expand = true
        self.add_overlay(@stack)
        @bouton = Gtk::Button.new(label: "Retour")
        @bouton.halign = :start
        @bouton.valign = :end
        @bouton.signal_connect("clicked") do
            if @stack.visible_child == @monde
                self.quitter()
            else
                self.retour()
            end
        end

        self.add_overlay(@bouton)
        @stack.show_all()
        self.show_all()
    end

    def calculNbEtoiles()
        @nbEtoiles = 0
        @etoiles = []
        [@grillesF, @grillesM, @grillesD].each() do |d|
            ed = []
            d.each() do |g|
              e = GestionBase.recupScore(@fenetre.joueur.id, g) / (g.scoreMax/4)
	      e = e > 3 ? 3 : (e < 0 ? 0 : e)
              ed.push(e)
              @nbEtoiles += e
            end
            @etoiles.push(ed)
        end
    end

    # Fonction appellé par le monde après le choix du continent
    def choix(continent)
        @stack.set_visible_child_name(continent)
    end

    # Lancement d'une grille
    def lancer(g)
        @dernier = @stack.visible_child_name()

        @stack.add_named(AfficheurJeu.new(g, self, "aventure"), "grille")
        self.show_all()
        @stack.set_visible_child_name("grille")
    end

    # Fin d'une grille
    def finJeu()
        g = @stack.visible_child()
        self.calculNbEtoiles()
        @stack.set_visible_child(@dernier)
        @stack.visible_child.refresh()
        @stack.remove_child(g)
    end    

    # Fonction appellé les continents pour revenir au monde
    def retour()
        @stack.set_visible_child(@monde)
        @stack.visible_child.refresh()
    end

    # Retour au menu principal
    def quitter()
        @fenetre.finAventure()
    end

    def joueur()
        @fenetre.joueur
    end
end
