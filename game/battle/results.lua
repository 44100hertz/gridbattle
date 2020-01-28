local oop = require 'src/oop'
local image = require 'src/image'

local results = oop.class {
   transparent = true,
}

function results:init (result)
   self.image = image('battle/results')
   self.frame = result
end

function results:update ()
   if GAME.input:hit_any_button() then
      GAME.scene:pop()
      GAME.scene:pop()
   end
end

function results:draw ()
   self.image:draw(0, 0, nil, self.frame)
end

return results
