require "input"

local actors

local stage = {
   size = {x=6, y=3},
   offset = {x=-20, y=54},
   spacing = {x=40, y=24},
}

space = {
   occupy = function (actor, x, y)
      if x >= 1 and x <= stage.size.x and
      y >= 1 and y <= stage.size.y then
	 local panel = stage[x][y]
	 local top = panel
	 while top.under do top = top.under end
	 if top.class.walkable then
	    actor.over = top
	    top.under = actor
	    return true
	 end
      end
   end,

   free = function (x, y)
      local panel = stage[x][y]
      panel.under = nil
      return top
   end,
}

battle = {
   loadset = function (set)
      actors = {}
      battle.turf = set.stage.turf

      -- Stage panels ALWAYS in slots 1-18
      local panel = require "battle/actors/panel"
      for x = 1,stage.size.x do
	 stage[x] = {}
	 for y = 1,stage.size.y do
	    local actor = {
	       class=panel,
	       x=x, y=y, z=-8,
	       side = battle.turf[y]<x and "left" or "right"
	    }
	    stage[x][y] = actor
	    table.insert(actors, actor)
	 end
      end

      local player = {
	 class=require "battle/actors/Player",
	 x=set.stage.spawn.x, y=set.stage.spawn.y, side="left"
      }
      table.insert(actors, player)
   end,

   addactor = function (actor)
      table.insert(actors, actor)
   end
}

local zalign = function()
   for x = 1,stage.size.x do
      for y = 1,stage.size.y do
	 local actor = stage[x][y]
	 while actor.under do
	    local z = actor.z + actor.class.height
	    actor = actor.under
	    actor.z = z
	 end
      end
   end
end

return {
   init = function ()
      battle.loadset(require "battle/sets/test")
      for _,v in ipairs(actors) do
	 if v.class.start then v.class.start(v) end
      end
   end,

   draw = function ()
      love.graphics.clear(100, 200, 150, 255)
      table.sort(actors, function(o1,o2)
		    return (o1.y < o2.y) and not (o1.z > o2.z)
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
      zalign()
      for _,v in ipairs(actors) do
	 if v.class.update then v.class.update(v) end
      end
   end
}
