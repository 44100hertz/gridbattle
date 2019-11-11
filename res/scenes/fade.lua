local oop = require 'src/oop'

local fade= {
   transparent = true,
}

function fade.new (length, is_in, after)
   local self = oop.instance(fade, {})
   self.length, self.is_in, self.after = length, is_in, after
   self.starttime = love.timer.getTime()
   return self
end

function fade:update ()
   if love.timer.getTime() - self.starttime > self.length then
      self.after()
   end
end

function fade:draw ()
   local elapsed = love.timer.getTime() - self.starttime
   local darkness = elapsed / self.length
   if self.is_in then darkness = 1.0 - darkness end

   love.graphics.setColor(0, 0, 0, darkness)
   love.graphics.rectangle('fill', 0, 0, GAME.width, GAME.height)
   love.graphics.setColor(1.0, 1.0, 1.0, 1.0)
end

return fade
