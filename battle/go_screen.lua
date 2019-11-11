local oop = require 'src/oop'
local image = require 'src/image'

local go = {
   transparent = true,
   transition_length = 0.5
}

function go:new ()
   local self = oop.instance({}, go)
   self.image = image.new('battle/start')
   self.start_time = love.timer.getTime()
   return self
end

function go:update ()
   local elapsed = self:get_elapsed()
   if elapsed >= 1 then
      (require 'src/scene'):pop()
   end
end

function go:draw ()
   local elapsed = self:get_elapsed()
   self.image.yscale = math.sqrt(1 - elapsed) * 3
   self.image:draw(GAME.width / 2, GAME.height / 2)
end

function go:get_elapsed ()
   return (love.timer.getTime() - self.start_time) / self.transition_length
end

return go
