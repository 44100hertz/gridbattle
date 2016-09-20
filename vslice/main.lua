player = {}

local state_idle, state_move = 0, 1
player.state = state_idle

x, x_goal, y, y_goal = 0,0,0,0

player.pos = {0,0}
player.img = love.graphics.newImage('ben.png')
player.width = player.img:getWidth()
player.height = player.img:getHeight()

player.frames = {
   love.graphics.newQuad(0, 0, 49, 60, player.width, player.height),
   love.graphics.newQuad(0, 60, 49, 60, player.width, player.height)
}

function player.update()
   if player.state==state_idle then
      player.idle()
   end
   if player.state==state_move then
      player.move()
   end
end

function player.idle()
   player.frame = player.frames[1]
   player.state = state_idle   
   if love.keyboard.isDown('a') then
      x_goal=x-40
      player.state = state_move
   end
   if love.keyboard.isDown('o') then
      y_goal=y+24
      player.state = state_move
   end
   if love.keyboard.isDown('e') then
      y_goal=y-24
      player.state = state_move
   end
   if love.keyboard.isDown('u') then
      x_goal=x+40
      player.state = state_move
   end
end

function player.move()
   if((x + y) % 8 < 4) then player.frame = player.frames[1]
   else player.frame = player.frames[2]
   end
   if x_goal < x then x=x-2 end
   if x_goal > x then x=x+2 end
   if y_goal < y then y=y-2 end
   if y_goal > y then y=y+2 end
   if x==x_goal and y==y_goal then
      player.state=state_idle
   end
end

stage = {}

function love.load()
   love.window.setMode(480,320)
   stage.img = love.graphics.newImage('stage.png')
end

function love.draw()
   
   player.update()
   canvas = love.graphics.newCanvas()
   canvas:renderTo(function()
	 love.graphics.draw(stage.img, 0, 0, 0, 1, 1, 0, 0)
	 love.graphics.draw(player.img, player.frame, x, y)
   end)
   canvas:setFilter("nearest", "nearest")
   love.graphics.draw(canvas, 0, 0, 0, 2, 2)
end

function love.update(dt)
end

