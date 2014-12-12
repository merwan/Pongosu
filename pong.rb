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

  def initialize(window)
    @window = window
    @color = Gosu::Color::GREEN
    @width = 5
    @height = 5
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

  def reset
    @x = @window.width / 2
    @y = @window.height / 2
    @vx = 5
    @vy = 3
    @vx = -@vx if Random.rand(2) == 1
    @vy = -@vy if Random.rand(2) == 1
  end

  private

  def bounce_on_wall
    @vy = -@vy
  end

  def collide_wall?
    @y <= 0 || @y >= @window.height
  end
end

class Score
  def initialize(window)
    @window = window
    @player1 = 0
    @player2 = 0
  end

  def draw
    draw_score(@player1, :player1)
    draw_score(@player2, :player2)
  end

  def draw_score(score, player)
    image = Gosu::Image.from_text(@window, score, Gosu::default_font_name, 100)
    if player == :player1
      xoffset = -2*image.width
    else
      xoffset = image.width
    end
    image.draw(@window.width / 2 + xoffset, 10, 0)
  end

  def point_player1
    @player1 += 1
  end

  def point_player2
    @player2 += 1
  end
end

class PongGame < Gosu::Window
  def initialize(width=800, height=600, fullscreen=false)
    super
    @paddle1 = Paddle.new(self, 10, Gosu::KbE, Gosu::KbD)
    @paddle2 = Paddle.new(self, width - 20, Gosu::KbUp, Gosu::KbDown)
    @ball = Ball.new(self)
    @ball.reset
    @score = Score.new(self)
    @pause = true
  end

  def button_down(id)
    self.close if id == Gosu::KbEscape
    @pause = false if id == Gosu::KbSpace
  end

  def update
    @paddle1.update
    @paddle2.update
    return if @pause
    update_collisions
    @ball.update
    update_score
  end

  def update_collisions
    if @paddle1.collide?(@ball) || @paddle2.collide?(@ball)
      @ball.bounce
    end
  end

  def update_score
    if @ball.x < 0
      @score.point_player2
      new_point
    end
    if @ball.x > self.width
      @score.point_player1
      new_point
    end
  end

  def new_point
    @pause = true
    @ball.reset
  end

  def draw
    @paddle1.draw
    @paddle2.draw
    @ball.draw
    @score.draw
  end
end

PongGame.new.show
