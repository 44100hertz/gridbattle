require "sheet"
require "stage"
require "player"
require "input"

local canvas = love.graphics.newCanvas()

function love.load()
   stage.init()
   player.init()
   love.window.setMode(480,320)
end

function love.draw()
   input.update()
   player.update()
   canvas:renderTo(function()
	 love.graphics.clear(100,200,150,255)
	 stage.draw()
	 player.draw()
   end)
   canvas:setFilter("nearest", "nearest")
   love.graphics.draw(canvas, 0, 0, 0, 2, 2)
end
