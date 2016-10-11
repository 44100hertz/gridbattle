require "sheet"
require "input"
require "battle/stage"
require "battle/actors/Player"

require "Animation"
local ben_sheet = require "battle/anim/ben"

local canvas = love.graphics.newCanvas()
local canvas_scale = 4
local game_size = {x=240, y=160}
local battle = {}
local actors = {}

function battle.load()
   ben = Animation:new(ben_sheet)
   
   love.window.setMode(game_size.x * canvas_scale,
		       game_size.y * canvas_scale)
   
   stage.init()
   actors[1] = Player:new()
   
   for o,_ in ipairs(actors) do actors[o]:init() end
end

function battle.draw()
   canvas:renderTo(function()
	 love.graphics.clear(100, 200, 150, 255)
	 stage.draw()
	 for o,_ in ipairs(actors) do actors[o]:draw() end
   end)
   canvas:setFilter("nearest", "nearest")
   love.graphics.draw(canvas, 0, 0, 0, canvas_scale, canvas_scale)
end

function battle.update(dt)
   input.update()
   for o,_ in ipairs(actors) do actors[o]:update(dt) end
end

return battle
