--[[
   A stack of scenes, typically initialized inside GAME.scene. This allows
   scenes to be layered on top of one other, without necessarily knowing which
   scene lies beneath.
]]

local oop = require 'src/oop'

local scene = oop.class()

function scene:init()
   self.stack = {}
end

-- A scene object should have the following fields:
--   object:update(input)
--   object:draw()
--   object.transparent         if true, draw the scene below this one
function scene:push (mod)
   table.insert(self.stack, mod)
end

function scene:top (distance)
   return self.stack[#self.stack - (distance or 0)]
end

function scene:pop ()
   return table.remove(self.stack)
end

function scene:push_fade (fadeopts, mod)
   local fade = require 'scenes/fade'
   local length = fadeopts.length or 0.25
   local fadein = function ()
      self:pop()
      self:push(mod)
      self:push(fade(length, true, oop.bind_by_name(self, 'pop')))
   end
   self:push(fade(length, false, fadein))
end

function scene:update ()
   local inputs = GAME.input:update()
   if self:top().update then
      self:top():update(inputs)
   end
end

function scene:draw ()
   local pos = #self.stack
   while(self.stack[pos].transparent) do
      pos = pos - 1
   end
   while(self.stack[pos]) do
      if self.stack[pos].draw then self.stack[pos]:draw() end
      pos = pos + 1
   end
end

return scene
