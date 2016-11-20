local actors

local stage = {
   size = {x=6, y=3},
   offset = {x=-20, y=54},
   spacing = {x=40, y=24},
}

space = {
   getoccupant = function (x, y)
      if stage[x] and stage[x][y] then
	 return stage[x][y].occupant
      end
   end,

   occupy = function (actor, x, y, side)
      if side and stage[x] and stage[x][y]
	 and not (side and stage[x][y].side ~= side) and
	 not space.getoccupant(x, y)
      then
	 stage[x][y].occupant = actor
	 return true
      end
   end,

   free = function (x,y)
      stage[x][y].occupant = nil
   end,

   getfloor = function (x, y)
      local panel = stage[math.floor(x+0.5)][math.floor(y+0.5)]
      return panel.z + panel.class.height
   end,
}

local bg, bgquad

battle = {
   loadset = function (set)
      actors = {}
      battle.turf = set.stage.turf

      local panel = require "battle/actors/panel"
      for x = 1,stage.size.x do
	 stage[x] = {}
	 for y = 1,stage.size.y do
	    stage[x][y] = {}
	    local newactor = {
	       class=panel,
	       x=x, y=y, z=-8,
	       side = x <= battle.turf[y] and "left" or "right"
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

      bg = set.bg
      bg:setWrap("repeat", "repeat")
      bgquad = love.graphics.newQuad(0, 0, 272, 192, 32, 32)
   end,

   addactor = function (newactor)
      table.insert(actors, newactor)
   end
}

local time
return {
   init = function ()
      time = 0
      battle.loadset(require "battle/sets/test")
      for _,v in ipairs(actors) do
	 if v.class.start then v.class.start(v) end
      end
   end,

   update = function ()
      if input.start == 1 then
	 main.pushstate(require "battle/pause")
	 return
      end
      time = time + 1
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
      love.graphics.draw(bg, bgquad, (time/2)%32-31.5, (time/2)%32-32)
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
