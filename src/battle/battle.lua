require "Sheet"
require "input"

require "battle/stage"
require "battle/actors/Actor"
require "battle/actors/Player"

local canvas = love.graphics.newCanvas()
local battle = {}
local actors = {}

function battle.load()
   actors[1] = Player:new()
end

function battle.draw()
   canvas:renderTo(function()
	 love.graphics.clear(100, 200, 150, 255)
	 stage.draw()
	 for i,_ in ipairs(actors) do Actor.draw(actors[i]) end
   end)
   canvas:setFilter("nearest", "nearest")
   love.graphics.draw(canvas, 0, 0, 0, canvas_scale, canvas_scale)
end

function battle.update(dt)
   input.update()
   for i,_ in ipairs(actors) do Actor.update(actors[i], dt) end
end

return battle
