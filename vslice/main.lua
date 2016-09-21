require "player"
require "input"

stage = {}

local canvas = love.graphics.newCanvas()

function love.load()
   love.window.setMode(480,320)
   stage.img = love.graphics.newImage('stage.png')   
end

function love.draw()
   input.update()
   player.update()
   canvas:renderTo(function()
	 love.graphics.clear(100,200,150,255)
	 love.graphics.draw(stage.img, 0, 0, 0, 1, 1, 0, 0)
	 love.graphics.draw(player.img, player.frame, player.x, player.y)
   end)
   canvas:setFilter("nearest", "nearest")
   love.graphics.draw(canvas, 0, 0, 0, 2, 2)
end

function love.update(dt)
end
