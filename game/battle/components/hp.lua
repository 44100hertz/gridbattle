local hp = {}

function hp:init (actor, max_hp, hidden)
   self.actor = actor
   self.value = max_hp
   self.max = max_hp
   self.hidden = hidden
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

function hp:draw ()
   if self.hidden then
      return
   end
   local panel_height = self.actor.battle.panel_size.y
   local pos = self.actor:screen_pos() - point(200, panel_height/2)
   local hpstr = tostring(math.floor(self.value))
   -- draw shadow
   --love.graphics.setColor(0, 0, 0)
   --love.graphics.printf(hpstr, x-200+2, y-panel_height/2+2, 400, 'center')
   love.graphics.setColor(1, 1, 1)
   love.graphics.printf(hpstr, pos.x, pos.y, 400, 'center')
end

return hp
