local oop = require 'src/oop'

local hp = oop.class()

function hp:init (actor, max_hp)
   self.value = max_hp
   self.max = max_hp
   self.stage = actor.battle.stage
end

function hp:set (value)
   self.value = math.max(math.min(value, self.max), 0)
end

function hp:adjust (value)
   self:set(self.value + value)
end

function hp:get ()
   return self.value
end

function hp:is_zero ()
   return self.value == 0
end

function hp:draw (x, y)
   local hpstr = tostring(math.floor(self.value))
   love.graphics.printf(hpstr, x-200, y-self.stage.panel_size.y/2, 400, 'center')
end

return hp
