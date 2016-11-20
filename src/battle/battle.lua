local stage = require "battle/stage"

local actors

return {
   occupy = function (actor, x, y, side)
      local panel = stage:getpanel(x, y)
      if panel and
	 not (side and panel.side ~= side) and
	 not panel.occupant
      then
	 panel.occupant = actor
	 return true
      end
   end,

   free = function (x, y)
      stage:getpanel(x, y).occupant = nil
   end,

   getpanel = function (x, y)
      return stage:getpanel(x,y)
   end,

   loadset = function (set)
      actors = {}
      local turf = set.stage.turf

      local panel = require "battle/actors/panel"
      for x = 1,stage.width do
	 stage[x] = {}
	 for y = 1,stage.height do
	    stage[x][y] = {}
	    local newactor = {
	       class=panel,
	       x=x, y=y, z=-8,
	       side = x <= turf[y] and "left" or "right"
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

      for _,v in ipairs(set.actors) do table.insert(actors, v) end

      for _,v in ipairs(actors) do
	 if v.class.start then v.class.start(v) end
      end
   end,

   addactor = function (newactor)
      table.insert(actors, newactor)
      newactor.class.start(newactor)
   end,

   collide = function ()
      for _,send in ipairs(actors) do
	 for _,recv in ipairs(actors) do
	    if send.group ~= recv.group and
	       send.class.send and
	       recv.class.recv and
	       math.abs(send.x - recv.x)<0.75 and
	       math.abs(send.y - recv.y)<0.75
	    then
	       recv.class.collide(send)
	    end
	 end
      end
   end,

   update = function ()
      for _,v in ipairs(actors) do
	 if v.class.update then v.class.update(v) end
      end
   end,

   draw =  function ()
      table.sort(actors, function(o1, o2)
		    return (o1.y+(o1.z/40) < o2.y+(o2.z/40))
      end)
      for _,v in ipairs(actors) do
	 if v.class.draw then
	    local x = stage.offset.x + stage.spacing.x * v.x
	    local y = stage.offset.y + stage.spacing.y * v.y - v.z
	    v.class.draw(v, x, y)
	 end
      end
   end
}
