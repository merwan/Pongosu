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

  def collide?(ball)
    return @x <= ball.x && ball.x <= @x + @width &&
           @y <= ball.y && ball.y <= @y + @height
  end
end

class Ball
  attr_reader :x, :y

  def initialize(window, x, y)
    @window = window
    @color = Gosu::Color::GREEN
    @x = x
    @y = y
    @width = 5
    @height = 5
    @vx = 5
    @vy = 3
  end

  def update
    @x += @vx
    @y += @vy
    bounce_on_wall if collide_wall?
  end

  def draw
    @window.draw_quad(@x, @y, @color, @x, @y + @height, @color, @x + @width, @y + @height, @color, @x + @width, @y, @color)
  end

  def bounce
    @vx = -@vx
  end

  private

  def bounce_on_wall
    @vy = -@vy
  end

  def collide_wall?
    @y <= 0 || @y >= @window.height
  end
end

class PongGame < Gosu::Window
  def initialize(width=800, height=600, fullscreen=false)
    super
    @paddle1 = Paddle.new(self, 10, Gosu::KbE, Gosu::KbD)
    @paddle2 = Paddle.new(self, width - 20, Gosu::KbUp, Gosu::KbDown)
    @ball = Ball.new(self, width/2, height/2)
  end

  def button_down(id)
    self.close if id == Gosu::KbEscape
  end

  def update
    @paddle1.update
    @paddle2.update
    if @paddle1.collide?(@ball) || @paddle2.collide?(@ball)
      @ball.bounce
    end
    @ball.update
  end

  def draw
    @paddle1.draw
    @paddle2.draw
    @ball.draw
  end
end

PongGame.new.show
