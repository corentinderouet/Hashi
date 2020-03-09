require "gtk3"

class ListeClassement < Gtk::ScrolledWindow
	def initialize()
		super()
		self.set_policy(Gtk::PolicyType::NEVER, Gtk::PolicyType::AUTOMATIC)
		self.expand = true

		nbColonnes = 3
		types = []
		nbColonnes.times() { types.append(String) }
		@store = Gtk::ListStore.new(*types)

		[["1", "Joueur 1", "1520"],
		["2", "Joueur 3", "1260"],
		["3", "Joueur 5", "1240"],
		["4", "Joueur 2", "1080"],
		["5", "Joueur 4", "930"]].each()  do |x|
			iter = @store.append()
			iter.set_values(x)
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