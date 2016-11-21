--[[
   The main loop of a battle
   Should be required as module when loading a new state
--]]

local main = require "main"
local input = require "input"
local fonts = require "fonts"
local test = require "test"
local battle = require "battle/battle"
local data = require "battle/data"

local time
local bg, bgquad

local collide = function ()
   for _,send in ipairs(data.actors) do
      for _,recv in ipairs(data.actors) do
	 if send.class.group ~= recv.class.group and
	    send.class.send and
	    recv.class.recv
	 then
	    local size = send.class.size + recv.class.size
	    if math.abs(send.x - recv.x) < size and
	       math.abs(send.y - recv.y) < size
	    then
	       recv.class.recv(recv, send)
	    end
	 end
      end
   end
end

local loadset = function (set)
   data.actors = {}
   local turf = set.stage.turf

   local panel = require "battle/actors/panel"
   for x = 1,data.stage.numx do
      data.stage[x] = {}
      for y = 1,data.stage.numy do
	 data.stage[x][y] = {}
	 local newactor = {
	    class=panel,
	    x=x, y=y, z=-8,
	    side = (x <= turf[y]) and "left" or "right"
	 }
	 data.stage[x][y] = newactor
	 table.insert(data.actors, newactor)
      end
   end

   local player = {
      class=require "battle/actors/player",
      x=set.stage.spawn.x, y=set.stage.spawn.y, side="left"
   }
   table.insert(data.actors, player)

   for _,v in ipairs(set.actors) do table.insert(data.actors, v) end
   for _,v in ipairs(data.actors) do
      if v.class.start then v.class.start(v) end
   end
end


return {
   start = function (_, set)
      time = 0

      bg = set.bg
      bg:setWrap("repeat", "repeat")
      bgquad = love.graphics.newQuad(0, 0, 432, 272, 32, 32)

      loadset(set)
      test.print_table(data)
   end,

   update = function ()
      if input.start == 1 then
	 main.pushstate(require "battle/pause")
	 return
      end
      collide()
      for _,v in ipairs(data.actors) do
	 if v.class.update then v.class.update(v) end
      end
      for k,v in ipairs(data.actors) do
	 if v.despawn then table.remove(data.actors, k) end
      end
      time = time + 1
   end,

   draw = function ()
      love.graphics.draw(bg, bgquad,
			 math.floor((time/2)%32-31.5), math.floor((time/2)%32-32))

      table.sort(data.actors, function(o1, o2)
		    return (o1.y+(o1.z/40) < o2.y+(o2.z/40))
      end)
      for _,v in ipairs(data.actors) do
	 if v.class.draw then
	    local x = data.stage.x + data.stage.w * v.x
	    local y = data.stage.y + data.stage.h * v.y - v.z
	    v.class.draw(v, x, y)
	    if v.hp then
	       love.graphics.setFont(fonts.tinyhp)
	       love.graphics.print(v.hp, x-15, y-30)
	    end
	 end
      end
   end,
}
