--[[
   A set of functions that any given ingame actor can call
--]]

local data = require "src/battle/data"
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

   addactor_raw = function (newactor)
      table.insert(data.actors, newactor)
      if newactor.class.start then newactor.class.start(newactor) end
   end,

   addactor = function (newactor)
      local dupactor = {}
      for k,v in pairs(newactor) do
	 dupactor[k] = v
      end
      table.insert(data.actors, dupactor)
      if dupactor.class.start then dupactor.class.start(dupactor) end
   end,

   signal = function (from, to, signal, ...)
      fun = to.class[signal]
      if fun then fun(to, from, ...) end
   end
}
