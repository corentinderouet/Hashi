require 'active_record'
ActiveRecord::Base.establish_connection(adapter: 'sqlite3', database: 'base.sqlite')

# Initialisation et création des tables
class Migration < ActiveRecord::Migration[4.2]
	def change
		if ActiveRecord::Base.connection.table_exists?(:joueurs)
		    drop_table :joueurs
		end
	
		if ActiveRecord::Base.connection.table_exists?(:grilleDbs)
		    drop_table :grilleDbs
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

		if ActiveRecord::Base.connection.table_exists?(:phrasesAventures)
		
			drop_table :phrasesAventures
		end
		
		create_table :joueurs do |t|
			t.string :pseudo
		end

		create_table :grilleDbs do |t|
			t.text :grilleSer
			t.text :grilleSolution
		end
		
		create_table :difficultes do |t|
			t.string :niveau
		end

		create_table :modes do |t|
			t.string :mode_jeu
		end

		create_table :joue do |t|
			t.belongs_to :joueurs
			t.belongs_to :grilleDb
			t.integer :score
		end

		create_table :phrasesAventures do |t|
			t.string :texteBot
			t.integer :idZoneScore
		end
	end
end

Migration.migrate(:up)
