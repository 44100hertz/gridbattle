--[[
   A set of functions that any given ingame actor can call
--]]

local anim = require "src/anim"
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

   addactor = function (actor, class)
      if not class.__index then class.__index = class end
      setmetatable(actor, class)
      table.insert(data.actors, actor)
      if actor.start then actor:start() end
      actor.image = love.graphics.newImage(actor.img)
      actor.sheet[7] = actor.image:getWidth()
      actor.sheet[8] = actor.image:getHeight()
      actor.anim = anim.sheet(unpack(actor.sheet))
      actor.time = 0
      if actor.states and actor.states.idle then
         actor.state = actor.states.idle
      end
   end,

   signal = function (from, to, signal, ...)
      fun = to[signal]
      if fun then fun(to, from, ...) end
   end
}
