local oop = require 'src/oop'
local image = require 'src/image'

local go = oop.class{
   transparent = true,
   transition_length = 0.5
}

function go:init ()
   self.image = image('battle/start.png', {base = {rect={0,0,240,160}, origin={120,80}}})
   self.start_time = love.timer.getTime()
end

function go:update ()
   local elapsed = self:get_elapsed()
   if elapsed >= 1 then
      GAME.scene:pop()
   end
end

function go:draw ()
   local elapsed = self:get_elapsed()
   self.image.scale.y = math.sqrt(1 - elapsed) * 3
   self.image:draw((GAME.size * 0.5):unpack())
end

function go:get_elapsed ()
   return (love.timer.getTime() - self.start_time) / self.transition_length
end

return go
