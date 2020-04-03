require "gtk3"
require_relative "AfficheurGrille"
require_relative "Timer"
require_relative "Didacticiel"

# Widget Gtk permettant d'afficher un plateau de jeu
class AfficheurJeu < Gtk::Paned

    # @afficheurGrille => Widget afficheur grille
    # @timer => Label du timer
    # @annuler => Bouton annuler
    # @refaire => Bouton refaire
    # @hypothese => Bouton hypothèse
    # @verif => Bouton vérification
    # @aidePos => Bouton aide position
    # @aideTech => Bouton aide technique
    # @pause => Bouton pause
    # @menu => Menu de droite

    # Constructeur
    #
    # === Parametres
    #
    # * +grille+ => Grille à afficher
    # * +fenetre+ => Fenetre principale
    # * +type+ => "entrainemen", "classe", "aventure" 
    def initialize(grille, fenetre, type)
        super(Gtk::Orientation.new(0))
        @paused = false
        @type = type
        @fenetre = fenetre

        @grilleDb = grille
        @grille = YAML.load(@grilleDb.grilleSolution)
        @grille.nbAides ||= 0
        @nbAides = @grille.nbAides
        @afficheurGrille = AfficheurGrille.new(@grille, true, self)

        @menu = Gtk::Box.new(Gtk::Orientation.new(1), 0)
        @menu.spacing = 5
        c = Gtk::Label.new("")
        c.expand = true
        @menu.add(c)
        @boutonContinuer = Gtk::Button.new(:label => "Continuer")
        @boutonContinuer.signal_connect("clicked") { |widget| self.remove(@menu); self.add1(@afficheurGrille); self.show_all(); @paused = false; @timer.reprendre() }
        @boutonRegles = Gtk::Button.new(:label => "Didacticiel")
        @boutonRegles.signal_connect("clicked") { |widget| @didacticiel = Didacticiel.new(); }
        @boutonQuitter = Gtk::Button.new(:label => "Quitter")
        @boutonQuitter.signal_connect("clicked") do |widget|
            if @type == "classe"
                d = Gtk::MessageDialog.new(:buttons => :ok_cancel)
                d.text = "Votre progression sur cette grille sera effacée si vous quittez"
                d.message_type = :question
                r = d.run == :ok
                d.destroy
                fenetre.finJeu() if r
            else
                @grille.timer = @timer.secondes
                @grille.nbAides = @nbAides
                @grilleDb.grilleSolution = @grille.to_yaml()
                GestionBase.changerScore(fenetre.joueur.id, @grilleDb, 0)
                puts("Sauvegardé")
                fenetre.finJeu()
            end
        end
        @menu.add(@boutonContinuer)
        @menu.add(@boutonRegles)
        @menu.add(@boutonQuitter)

        c = Gtk::Label.new("")
        c.expand = true
        @menu.add(c)

        boxVerticale = Gtk::Box.new(Gtk::Orientation.new(1), 0)
        @timer = Timer.new(@grille.timer)
        @timer.margin_top = 15
        boxVerticale.add(@timer)

        @annuler = Gtk::Button.new(:label => "Annuler")
        @annuler.margin_top = 15
        boxVerticale.add(@annuler)
        @annuler.signal_connect("clicked") { |widget| @grille.annuler(); @afficheurGrille.queue_draw() }

        @refaire = Gtk::Button.new(:label => "Refaire")
        boxVerticale.add(@refaire)
        @refaire.signal_connect("clicked") { |widget| @grille.refaire(); @afficheurGrille.queue_draw() }

        @verif = Gtk::Button.new(:label => "Vérification")
        boxVerticale.add(@verif)
        @verif.signal_connect("clicked") { |widget| @nbAides += 3*@grille.verification(); @afficheurGrille.queue_draw() }

        @hypothese = Gtk::Stack.new()
        @boutonHypothese = Gtk::Button.new(:label => "Hypothèse")
        @boutonHypothese.signal_connect("clicked") { |widget| @grille.commencerHypothese(); @hypothese.visible_child = @boxHypothese; @afficheurGrille.queue_draw() }
        @hypothese.add_named(@boutonHypothese, "Inactif")

        @boxHypothese = Gtk::Box.new(Gtk::Orientation.new(0), 0)
        @boutonValiderHypothese = Gtk::Button.new(:label => "Valider")
        @boutonValiderHypothese.signal_connect("clicked") { |widget| @grille.validerHypothese(); @hypothese.visible_child = @boutonHypothese; @afficheurGrille.queue_draw() }
        @boutonValiderHypothese.hexpand = true
        @boutonAnnulerHypothese = Gtk::Button.new(:label => "Annuler")
        @boutonAnnulerHypothese.signal_connect("clicked") { |widget| @grille.annulerHypothese(); @hypothese.visible_child = @boutonHypothese; @afficheurGrille.queue_draw() }
        @boutonAnnulerHypothese.hexpand = true

        @boxHypothese.add(@boutonAnnulerHypothese)
        @boxHypothese.add(@boutonValiderHypothese)
        @hypothese.add_named(@boxHypothese, "Actif")
        @hypothese.visible_child = @boutonHypothese
        boxVerticale.add(@hypothese)

        @reinitialiser = Gtk::Button.new(:label => "Réinitialiser")
        boxVerticale.add(@reinitialiser)
        @reinitialiser.signal_connect("clicked") { |widget| @grille.reinitialiser(); @afficheurGrille.queue_draw() }


        box = Gtk::Box.new(Gtk::Orientation.new(1), 0)
        box.margin_top = 15
        box.vexpand = true

        box.add(Gtk::Label.new("Aide :"))

        @aidePos = Gtk::Button.new(:label => "Position")
        @aidePos.margin_top = 5
        box.add(@aidePos)
        @aidePos.signal_connect("clicked") do |widget|
            @aide ||= @grille.obtenirAide()
            puts("avant " + @nbAides.to_s)
            @nbAides += @aide.niveau == 1 ? 5 : @aide.niveau == 2 ? 3 : 1
            puts("après " + @nbAides.to_s)
            @afficheurGrille.cercleAide = @aide.caseJeu
            @afficheurGrille.queue_draw()
            @aidePos.sensitive = false
        end

        @aideTech = Gtk::Button.new(:label => "Technique")
        box.add(@aideTech)
        @aideTech.signal_connect("clicked") do |widget|
            @aide ||= @grille.obtenirAide()
            puts("avant " + @nbAides.to_s)
            @nbAides += @aide.niveau == 1 ? 5 : @aide.niveau == 2 ? 3 : 1
            puts("après " + @nbAides.to_s)
            @description.text = @aide.description
            @afficheurGrille.queue_draw()
            @aideTech.sensitive = false
        end

        if @type == "aventure"
            @aideTech.sensitive = false
            @aidePos.sensitive = false
        end

        @description = Gtk::Label.new("")
        @description.line_wrap = true
        box.add(@description)

        boxVerticale.add(box)
        @pause = Gtk::Button.new(:label => "Pause")
        boxVerticale.add(@pause)
        @pause.signal_connect("clicked") { |widget| @timer.pause(); self.remove(@afficheurGrille); self.add1(@menu); self.show_all(); @paused = true }

        self.add1(@afficheurGrille)
        self.add2(boxVerticale)
        self.set_wide_handle(true)
        #self.set_position(1000)
        #puts(self.allocation.width)
        self.signal_connect("draw") do
            self.set_position(self.allocation.width* (@paused ? 1 : 0.80))
            print(nil)
        end
    end

    def aJoue()
        if @type != "aventure" 
            @aide = nil
            @afficheurGrille.cercleAide = nil
            @description.text = ""
            @aideTech.sensitive = true
            @aidePos.sensitive = true
        end
        if @grille.grilleFinie?()
            @grille.timer = @timer.secondes
            @grille.nbAides = @nbAides
            @grilleDb.grilleSolution = @grille.to_yaml()
            GestionBase.changerScore(@fenetre.joueur.id, @grilleDb, 0)
            puts("Sauvegardé")
            d = Gtk::MessageDialog.new()
            d.text = "Score final: #{GestionBase.recupScore(@fenetre.joueur.id, @grilleDb)}"
            d.message_type = :info
            d.run
            d.destroy
            @fenetre.finJeu()
        end
    end
end
