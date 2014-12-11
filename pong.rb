require 'gosu'

class PongGame < Gosu::Window
  def initialize(width=800, height=600, fullscreen=false)
    super
  end

  def button_down(id)
    self.close if id == Gosu::KbEscape
  end
end

PongGame.new.show
