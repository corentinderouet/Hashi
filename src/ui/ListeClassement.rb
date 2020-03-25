require "gtk3"

class ListeClassement < Gtk::ScrolledWindow
    # Constructeur
    #
    # === Paramètres
    #
    # * +difficulté+ - Niveau de difficulté (1 = facile, 2 = moyen, 3 = difficile) 
    def initialize(difficulté)
        super()
        self.set_policy(Gtk::PolicyType::NEVER, Gtk::PolicyType::AUTOMATIC)
        self.expand = true

        nbColonnes = 3
        types = [Integer, String, Integer]
        @store = Gtk::ListStore.new(*types)
        
        joueurs = GestionBase.recupJoueurAll()

        c = joueurs.map() { |x| [x, GestionBase.recupScoreTotal(x.id, difficulté)] }
        c.sort() { |a,b| b[1] <=> a[1] }

          c.each_index()  do |i|
             iter = @store.append()
             iter.set_values([i+1, c[i][0].pseudo, c[i][1]])
         end

         @tree = Gtk::TreeView.new(@store)
         @tree.show_expanders = false

         colonnes = ["Rang", "Nom d'utilisateur", "Score"]
         colonnes.each_index() do |i|
             renderer = Gtk::CellRendererText.new()
             colonne = Gtk::TreeViewColumn.new(colonnes[i], renderer, {:text => i})
             colonne.expand = true
             @tree.append_column(colonne)
         end
         self.add(@tree)
    end
end
