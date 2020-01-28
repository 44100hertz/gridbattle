local player = {}

function player:update ()
   local autofire = GAME.input:down'b' and 20 or 5
   local delay = GAME.input:down'b' and 0.03 or 0.08
   local p = self.pos:copy()
   if GAME.input:hit_with_repeat('du', delay, autofire) then
      p.y = p.y - 16
   elseif GAME.input:hit_with_repeat('dd', delay, autofire) then
      p.y = p.y + 16
   elseif GAME.input:hit_with_repeat('dl', delay, autofire) then
      p.x = p.x - 16
   elseif GAME.input:hit_with_repeat('dr', delay, autofire) then
      p.x = p.x + 16
   end
   if self:is_walkable(p) then
      self.pos = p
   end
end

return player
