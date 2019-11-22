local oop = require 'src/oop'

local fade = oop.class {
   transparent = true,
}

function fade:init (length, is_in, after)
   self.length, self.is_in, self.after = length, is_in, after
   self.starttime = love.timer.getTime()
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
