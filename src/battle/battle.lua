require "input"

local canvas = love.graphics.newCanvas()
local battle = {}
local actors = {}
local stage = {
   size = {x=6, y=3},
   offset = {x=20, y=82},
   spacing = {x=40, y=24},
}

function battle.load()
   -- Player
   actors[1] = {class=require "battle/actors/Player",
		x=2, y=2, z=1, side="left",
   }

   -- Add in stage panels
   local stageactor = require "battle/stage"
   local index = #actors+1
   for x = 1,6 do
      for y = 1,3 do
	 actors[index] = {
	    class=stageactor,
	    x=x, y=y, sz=0,
	    side = (x<4) and "left" or "right"
	 }
	 index = index + 1
      end
      index = index + 1
   end

   for _,v in ipairs(actors) do
      if v.class.start then v.class.start(v) end
   end
end

function battle.draw()
   love.graphics.clear(100, 200, 150, 255)
   for _,v in ipairs(actors) do
      if v.class.draw then
	 local x = v.x * stage.offset.x + stage.spacing.x * v.x
	 local y = v.y * stage.offset.y + stage.spacing.y * v.y
	 v.class.draw(v, x, y)
      end
   end
   love.graphics.draw(canvas, 0, 0, 0, canvas_scale, canvas_scale)
end

function battle.update()
   input.update()
   for _,v in ipairs(actors) do
      if v.class.update then v.class.update(v) end
   end
end

return battle
