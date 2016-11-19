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

   getfloor = function (x, y)
      local panel = stage[math.floor(x+0.5)][math.floor(y+0.5)]
      return panel.z + panel.class.height
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
	    local newactor = {
	       class=panel,
	       x=x, y=y, z=-8,
	       side = battle.turf[y]<x and "left" or "right"
	    }
	    stage[x][y] = newactor
	    table.insert(actors, newactor)
	 end
      end

      local player = {
	 class=require "battle/actors/player",
	 x=set.stage.spawn.x, y=set.stage.spawn.y, side="left"
      }
      table.insert(actors, player)
   end,

   addactor = function (newactor)
      table.insert(actors, newactor)
   end
}

return {
   init = function ()
      battle.loadset(require "battle/sets/test")
      for _,v in ipairs(actors) do
	 if v.class.start then v.class.start(v) end
      end
   end,

   update = function ()
      for _,send in ipairs(actors) do
	 for _,recv in ipairs(actors) do
	    if send.class.send and
	       recv.class.recv and
	       math.abs(send.x - recv.x)<0.75 and
	    math.abs(send.y - recv.y)<0.75 then
	       recv.class.collide(send)
	    end
	 end
      end
      for _,v in ipairs(actors) do
	 if v.class.update then v.class.update(v) end
      end
   end,

   draw = function ()
      love.graphics.clear(100, 200, 150, 255)
      table.sort(actors, function(o1, o2)
		    return (o1.y+(o1.z/40) < o2.y+(o2.z/40))
      end)
      for _,v in ipairs(actors) do
	 if v.class.draw then
	    local x = stage.offset.x + stage.spacing.x * v.x
	    local y = stage.offset.y + stage.spacing.y * v.y + v.z
	    v.class.draw(v, x, y)
	 end
      end
   end,
}
