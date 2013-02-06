require 'gosu'

class Window < Gosu::Window
	def initialize
		super 720,480,false
		self.caption = "Pong"
		@ball = Ball.new(self)
		@ball.warp(360,240)
	end

	def update 
		@ball.draw
		@ball.move
	end

	def draw
		@ball.draw
	end

	def button_down(id)
		if id == Gosu::KbEscape then 
			close
		end
	end

end

class Board
	def initialize 
		@image
		@x 
		@y
		@velocity

	end

	def moveUp

	end

	def moveDown

	end
end

class Ball
	def initialize(window)
		@image = Gosu::Image.new(window,"ball.png",false)
		@x,@y = 360,240
		@velocity = 10
		@angle = 45

	end

	def warp(x,y)
		@x,@y = x,y
	end

	def move
		if (@y >= 0) & (@y <= 480) & (@x >= 0) & (@x <= 720) then
			@x += Gosu::offset_x(@angle,@velocity)
			@y += Gosu::offset_y(@angle,@velocity)
		else
			@angle += 90
			@x += Gosu::offset_x(@angle,@velocity)
			@y += Gosu::offset_y(@angle,@velocity)
		end
	end

	def draw 
		@image.draw_rot(@x,@y,1,@angle)
	end

end

window = Window.new
window.show