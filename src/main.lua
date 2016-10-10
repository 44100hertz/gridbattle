require "sheet"
require "input"
require "battle-stage"
require "stage_actor"

local canvas = love.graphics.newCanvas()
local canvas_scale = 4
local gameSize_x, gameSize_y = 240, 160

function love.load()
   stage.init()
   stage_actor.init()
   love.window.setMode(gameSize_x * canvas_scale, gameSize_y * canvas_scale)
end

function love.draw()
   input.update()
   stage_actor.update()
   canvas:renderTo(function()
	 love.graphics.clear(100,200,150,255)
	 stage.draw()
	 stage_actor.draw()
   end)
   canvas:setFilter("nearest", "nearest")
   love.graphics.draw(canvas, 0, 0, 0, canvas_scale, canvas_scale)
end
