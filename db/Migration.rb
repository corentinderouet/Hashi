require 'active_record'

ActiveRecord::Base.establish_connection(adapter: 'sqlite3', database: 'base.sqlite')

# Initialisation et création des tables
class Migration < ActiveRecord::Migration[4.2]
    	def change
		if ActiveRecord::Base.connection.table_exists?(:joueur)
		#            drop_table :joueur
		end
	
		if ActiveRecord::Base.connection.table_exists?(:grilleDb)
		#            drop_table :users
		end
	
		if ActiveRecord::Base.connection.table_exists?(:difficulte)
		
		#            drop_table :servers
		end

		if ActiveRecord::Base.connection.table_exists?(:mode)
		
		#            drop_table :servers
		end

		if ActiveRecord::Base.connection.table_exists?(:joue)
		
		#            drop_table :servers
		end

		if ActiveRecord::Base.connection.table_exists?(:phrasesAventure)
		
		#            drop_table :servers
		end
		
		create_table :joueur do |t|
			t.string :pseudo
		end

		create_table :grilleDb do |t|
			t.text :grilleSer
			t.text :grilleSolution
		end
		
		create_table :difficulte do |t|
			t.string :niveau
		end

		create_table :mode do |t|
			t.string :mode_jeu
		end

		create_table :joue do |t|
			t.belongs_to :joueur
			t.belongs_to :grilleDb
			t.integer :score
		end

		create_table :phrasesAventure do |t|
			t.string :texteBot
			t.integer :idZoneScore
		end
    	end
end

Migration.migrate(:up)
