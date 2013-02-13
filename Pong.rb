require 'gosu'

class Window < Gosu::Window
	# board size 30 X 298
	def initialize
		super 1440,720,false
		self.caption = "Pong"
		@ball = Ball.new(self)
		@ball.warp(720,360)
		@board1 = Board.new(self,15,360)
		@board2 = Board.new(self,1425,360) 
		@player1Win = Gosu::Image.new(self,"P1_wins.png",false)
		@player2Win = Gosu::Image.new(self,"P2_wins.png",false)
	end

	def update 
		@ball.draw
		final = @ball.freeMove(getBoard1,getBoard2)
		if button_down? Gosu::KbS then
			@board1.moveDown(self)
		elsif button_down? Gosu::KbW then
			@board1.moveUp(self)
		elsif button_down? Gosu::KbDown then
			@board2.moveDown(self)
		elsif button_down? Gosu::KbUp then
			@board2.moveUp(self)
		elsif button_down? Gosu::KbEscape then
			close
		end

	end

	

	def getBoard1
		return @board1
	end

	def getBoard2
		return @board2
	end


	def draw
		@ball.draw
		@board1.draw
		@board2.draw

	end

	def drawEnding(boolean)
		if boolean then
			@player1Win.draw_rot(720,360,1,0)
		else
			@player2Win.draw_rot(720,360,1,0)
		end
	end



end

class Board
	# board size 30 X 298
	def initialize(window,x,y)
		@image = Gosu::Image.new(window,"board.png",false)
		@x,@y = x,y
		@velocity = 10

	end

	def moveUp(window)
		if (@y>0+0.5*@image::height)then
			@y -= @velocity
		end
	end

	def moveDown(window)
		if (@y<=window::height-0.5*@image::height) then
			@y += @velocity
		end
	end

	def getImage
		return @image
	end

	def getX 
		return @x
	end

	def getY
		return @y
	end

	def warp(x,y)
		@x,@y = x,y
	end

	def draw()
		@image.draw_rot(@x,@y,1,0)
	end
end

class Ball
	def initialize(window)
		@image = Gosu::Image.new(window,"ball.png",false)
		@x,@y = 720,360
		@velocity = 20
		@angle = 45
		@window = window
	end

	def warp(x,y)
		@x,@y = x,y
	end

	def freeMove(board1,board2)
		player1Win = true
		if (@y >= 0) & (@y <= 720) & (@x >= 0) & (@x <= 1440) then
			# hit left board
			if (@x <= board1.getX+0.5*board1.getImage.width) & (@y >= board1.getY-0.5*board1.getImage.height) & (@y <= board1.getY+0.5*board1.getImage.height) then
				turn(90)
			# hit right board
			elsif (@x >= board2.getX-0.5*board2.getImage.width) & (@y >= board2.getY-0.5*board2.getImage.height) & (@y <= board2.getY+0.5*board2.getImage.height) then
				turn(90)
			end
				
			@x += Gosu::offset_x(@angle,@velocity)
			@y += Gosu::offset_y(@angle,@velocity)
		# hit upper or down border
		elsif (@y > 720) | (@y < 0) then
			turn(90)
			@x += Gosu::offset_x(@angle,@velocity)
			@y += Gosu::offset_y(@angle,@velocity)
		# We got a winner!
		else
			if(@x < 0) then
				@window.drawEnding(false)
			elsif(@x > 720) then
				@window.drawEnding(true)
			end
		end
	end

	def turn(angle)
		@angle += angle
	end

	def draw 
		@image.draw_rot(@x,@y,1,@angle)
	end
end


window = Window.new
window.show