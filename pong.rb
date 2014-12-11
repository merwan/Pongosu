require 'gosu'

class PongGame < Gosu::Window
  def initialize(width=800, height=600, fullscreen=false)
    super
  end
end

PongGame.new.show
