require "player"

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
	 love.graphics.draw(player.img, player.frame, player.x, player.y)
   end)
   canvas:setFilter("nearest", "nearest")
   love.graphics.draw(canvas, 0, 0, 0, 2, 2)
end

function love.update(dt)
end
