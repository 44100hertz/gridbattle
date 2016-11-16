require "input"

local canvas = love.graphics.newCanvas()
local battle = {}
local actors = {}
local stage = {
   size = {x=6, y=3},
   offset = {x=-20, y=60},
   spacing = {x=40, y=24},
}

function battle.load()
   -- Player
   actors[1] = {class=require "battle/actors/Player",
		x=2, y=2, z=1, side="left",
   }

   -- Add in stage panels
   local stageactor = require "battle/stage"
   for x = 1,6 do
      for y = 1,3 do
	 actors[#actors+1] = {
	    class=stageactor,
	    x=x, y=y, z=0,
	    side = (x<4) and "left" or "right"
	 }
      end
   end

   for _,v in ipairs(actors) do
      if v.class.start then v.class.start(v) end
   end
end

function battle.draw()
   love.graphics.clear(100, 200, 150, 255)
   table.sort(actors, function(o1,o2)
		 return o1.y < o2.y or o1.z < o2.z
   end)
   for _,v in ipairs(actors) do
      if v.class.draw then
	 local x = stage.offset.x + stage.spacing.x * v.x
	 local y = stage.offset.y + stage.spacing.y * v.y
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
