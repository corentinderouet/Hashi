require 'active_record'
ActiveRecord::Base.establish_connection(adapter: 'sqlite3', database: 'base.sqlite')

# Initialisation et création des tables
class Migration < ActiveRecord::Migration[4.2]
	def change
		if ActiveRecord::Base.connection.table_exists?(:joueurs)
		    drop_table :joueurs
		end
	
		if ActiveRecord::Base.connection.table_exists?(:grille_dbs)
		    drop_table :grille_dbs
		end
	
		if ActiveRecord::Base.connection.table_exists?(:difficultes)
		
		    drop_table :difficultes
		end

		if ActiveRecord::Base.connection.table_exists?(:modes)
		
			drop_table :modes
		end

		if ActiveRecord::Base.connection.table_exists?(:joues)
		
			drop_table :joues
		end

		if ActiveRecord::Base.connection.table_exists?(:phrases_aventures)
		
			drop_table :phrases_aventures
		end
		
		create_table :joueurs do |t|
			t.string :pseudo
		end

		create_table :grille_dbs do |t|
			t.text :grilleSer
			t.text :grilleSolution
			t.string :niveau
			t.string :mode_jeu
		end
		
		create_table :difficultes do |t|
			t.string :niveau
		end

		create_table :modes do |t|
			t.string :mode_jeu
		end

		create_table :joues do |t|
			t.belongs_to :joueurs
			t.belongs_to :grilleDb
			t.integer :score
		end

		create_table :phrases_aventures do |t|
			t.string :texteBot
			t.integer :idZoneScore
		end
	end
end

Migration.migrate(:up)