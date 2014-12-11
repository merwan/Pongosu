require 'gosu'

class Paddle
  def initialize(window, x, key_up, key_down)
    @window = window
    @height = 100
    @width = 10
    @x = x
    @y = @window.height / 2 - @height / 2
    @color = Gosu::Color::RED
    @key_up = key_up
    @key_down = key_down
  end

  def update
    @y -= 5 if @window.button_down? @key_up
    @y += 5 if @window.button_down? @key_down
  end

  def draw
    @window.draw_quad(@x, @y, @color, @x, @y + @height, @color, @x + @width, @y + @height, @color, @x + @width, @y, @color)
  end
end

class PongGame < Gosu::Window
  def initialize(width=800, height=600, fullscreen=false)
    super
    @paddle1 = Paddle.new(self, 10, Gosu::KbE, Gosu::KbD)
    @paddle2 = Paddle.new(self, width - 20, Gosu::KbUp, Gosu::KbDown)
  end

  def button_down(id)
    self.close if id == Gosu::KbEscape
  end

  def update
    @paddle1.update
    @paddle2.update
  end

  def draw
    @paddle1.draw
    @paddle2.draw
  end
end

PongGame.new.show
