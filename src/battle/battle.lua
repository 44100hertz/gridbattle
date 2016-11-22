--[[
A set of functions that any given ingame actor can call
--]]

local data = require "battle/data"
local fonts = require "fonts"
local actors

return {
   occupy = function (actor, x, y, side)
      local panel = data.stage[x] and data.stage[x][y] or nil
      if panel and
	 not (side and panel.side ~= side) and
	 not panel.occupant
      then
	 panel.occupant = actor
	 return true
      end
   end,

   free = function (x, y)
      data.stage[x][y].occupant = nil
   end,

   getpanel = function (x, y)
      x,y = math.floor(x+0.5), math.floor(y+0.5)
      if data.stage[x] and data.stage[x][y] then
	 return data.stage[x][y]
      end
   end,

   addactor = function (newactor)
      table.insert(data.actors, newactor)
      if newactor.class.start then newactor.class.start(newactor) end
   end,

   signal = function (from, to, signal, ...)
      fun = to.class[signal]
      if fun then fun(to, from, ...) end
   end
}
