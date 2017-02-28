--[[
   A set of functions that any given ingame actor can call
--]]

local anim = require "src/anim"
local data = require "src/battle/data"
local actors = {}

return {
   addactor = function (actor, class)
      if not class.__index then class.__index = class end
      setmetatable(actor, class)
      table.insert(data.actors, actor)
      if actor.start then actor:start() end
      if actor.img then
         actor.image = love.graphics.newImage(actor.img)
      end
      if actor.sheet then
         actor.sheet[7] = actor.image:getWidth()
         actor.sheet[8] = actor.image:getHeight()
         actor.anim = anim.sheet(unpack(actor.sheet))
      end
      if actor.states and actor.states.idle then
         actor.state = actor.states.idle
      end
      actor.time = 0
      actor.z = 0
   end,

   signal = function (from, to, signal, ...)
      local fun = to[signal]
      if fun then fun(to, from, ...) end
   end
}
