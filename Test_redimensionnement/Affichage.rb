require "gtk3"

class Affichage < Gtk::DrawingArea

	def initialize(v_width, v_height)
		super()
		@v_width = v_width
		@v_height = v_height
		@ratio = 1.0 * @v_width / @v_height
        self.signal_connect("draw") { |event| on_draw() }
        self.signal_connect("configure-event") { |event| on_draw() }
        @formes = []
	end

	def width()
		return self.allocation.width()
	end

	def height()
		return self.allocation.height()
	end

	def coord_x(x)
		if self.width / @ratio > self.height
			return x * @v_y + (self.width - self.height * @ratio) / 2 + @v_x * 0.5
		else
			return x * @v_x + @v_x * 0.5
		end
	end

	def coord_y(y)
		if self.height * @ratio > self.width
			return y * @v_x + (self.height - self.width / @ratio) / 2 + @v_y * 0.5
		else
			return y * @v_y + @v_y * 0.5
		end
	end

	def scale(s)
		if self.width / @ratio > self.height
			return s * @v_y
		else
			return s * @v_x
		end
	end

	def on_draw
		@v_x = 1.0 * self.width / @v_width
		@v_y = 1.0 * self.height / @v_height
        cr = self.window.create_cairo_context  
        draw(cr)
    end

    def draw(cr)
    	cr.select_font_face("Arial", Cairo::FONT_SLANT_NORMAL, Cairo::FONT_WEIGHT_NORMAL)
        cr.set_font_size(scale(0.5)) 
    	(0..9).each() do |x|
    		(0..9).each() do |y|
    			#n = rand(1..25)
    			n = 1
    			if (n <= 8)
	    			cr.set_source_rgb(0, 0, 0)
	    			cr.arc(coord_x(x), coord_y(y), scale(0.3), 0, 2*Math::PI)
	        		cr.fill
	        		cr.set_source_rgb(1, 1, 1)
	        		cr.arc(coord_x(x), coord_y(y), scale(0.28), 0, 2*Math::PI)
	        		cr.fill
	       			cr.set_source_rgb(0, 0, 0)
	        		cr.move_to(coord_x(x) - scale(0.14), coord_y(y) + scale(0.18))
	        		cr.show_text(n.to_s())
	        	end
    		end
    	end
    end
end