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
        view.buffer.text = 
"   
    Règles :

    Techniques :

    Interface : 
"
        view.sensitive = false

        scroll = Gtk::ScrolledWindow.new()
        scroll.set_policy(:never, :automatic)
        scroll.expand = true
        scroll.add(view)

        bouton = Gtk::Button.new(label: "Quitter")
        bouton.signal_connect("clicked") { self.close() }
        bouton.margin_top = 10

        vbox.add(scroll)
        vbox.add(bouton)

        self.add(vbox)

        self.show_all()
    end
end
