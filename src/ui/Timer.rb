class Timer < Gtk::Label
    attr_reader :secondes

    def initialize(secondes)
      @secondes = secondes ? secondes : 0
      super(self.to_s())
      self.reprendre()
    end

    def to_s()
      m, s = @secondes.divmod(60)
      h, m = m.divmod(60)
      return "%02d:%02d:%02d" % [h, m, s]
    end

    def reprendre()
        @t = Thread.new() do
          while true do
            sleep(1)
            @secondes += 1
            self.text = self.to_s
          end
       end
    end

    def pause()
        @t.kill
    end
end
