local oop = require 'src/oop'

local hp = oop.class()

function hp:init (max_hp)
   self.value = max_hp
   self.max = max_hp
end

function hp:set (value, hidden)
   self.value = math.max(math.min(value, self.max), 0)
   self.hidden = hidden
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

function hp:draw (actor)
   if self.hidden then
      return
   end
   local x, y = actor:screen_pos()
   local panel_height = actor.battle.stage.panel_size.y
   local hpstr = tostring(math.floor(self.value))
   -- draw shadow
   --love.graphics.setColor(0, 0, 0)
   --love.graphics.printf(hpstr, x-200+2, y-panel_height/2+2, 400, 'center')
   love.graphics.setColor(1, 1, 1)
   love.graphics.printf(hpstr, x-200, y-panel_height/2, 400, 'center')
end

return hp
