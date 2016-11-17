require "input"

local actors

local stage = {
   size = {x=6, y=3},
   offset = {x=-20, y=60},
   spacing = {x=40, y=24},
}

battle = {}

battle.load = function (set)
   actors = {}
   battle.turf = set.stage.turf

   -- Stage panels ALWAYS in slots 1-18
   local panel = require "battle/actors/panel"
   for x = 1,stage.size.x do
      for y = 1,stage.size.y do
	 local actor = {
	    class=panel,
	    x=x, y=y, z=0,
	    side = battle.turf[y]<x and "left" or "right"
	 }
	 table.insert(actors, actor)
      end
   end

   local player = {
      class=require "battle/actors/Player",
      x=set.stage.spawn.x, y=set.stage.spawn.y, z=1, side="left"
   }
   table.insert(actors, player)
end

battle.addactor = function (actor)
   table.insert(actors, actor)
end

return {
   init = function ()
      battle.load(require "battle/sets/test")
      for _,v in ipairs(actors) do
	 if v.class.start then v.class.start(v) end
      end
   end,

   draw = function ()
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
   end,

   update = function ()
      for _,v in ipairs(actors) do
	 if v.class.update then v.class.update(v) end
      end
   end
}
