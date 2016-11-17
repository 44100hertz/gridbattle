require "input"

local battle = {}
local actors

battle.load = function (set)
   actors = {}

   -- Player
   local player = {
      class=require "battle/actors/Player",
      x=set.stage.spawn.x, y=set.stage.spawn.y, z=1, side="left"
   }
   table.insert(actors, player)

   -- Stage panels
   local stageactor = require "battle/stage"
   for x = 1,6 do
      for y = 1,3 do
	 local actor = {
	    class=stageactor,
	    x=x, y=y, z=0,
	    side = set.stage.turf[y]<x and "left" or "right"
	 }
	 table.insert(actors, actor)
      end
   end
end

battle.addactor = function (actor)
   table.insert(actors, actor)
end

battle.init = function ()
   battle.load(require "battle/sets/test")
   for _,v in ipairs(actors) do
      if v.class.start then v.class.start(v) end
   end
end

battle.draw = function ()
   local stage = {
      size = {x=6, y=3},
      offset = {x=-20, y=60},
      spacing = {x=40, y=24},
   }

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
end

battle.update = function ()
   input.update()
   for _,v in ipairs(actors) do
      if v.class.update then v.class.update(v) end
   end
end


return battle
