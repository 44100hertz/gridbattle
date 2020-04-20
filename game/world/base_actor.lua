local oop = require 'src/oop'
local battle = require 'battle/battle'

local proto = oop.class {
   visible = true,
   active = true,
}

-- [[ Internal functions ]]

function proto:init (world)
end

-- [[ Overloadable functions ]]

function proto:update (world)
end
function proto:collide (world, with)
end
function proto:rect ()
   return self.pos.x, self.pos.y, self.size.x, self.size.y
end

function proto:debug_draw ()
      if self.shape == 'point' then
         love.graphics.circle('line', self.pos.x+8, self.pos.y+8, 8)
      elseif self.shape == 'rectangle' then
         love.graphics.rectangle('line', self:rect())
      elseif self.shape == 'polyline' then
         love.graphics.line(self.line)
      end
end

-- [[ Callable functions ]]

function proto:enter_battle (name)
   GAME.scene:push_fade({}, battle(name))
end

return proto
