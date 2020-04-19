local player = {}

function player:update ()
   local autofire = GAME.input:down'b' and 20 or 5
   local delay = GAME.input:down'b' and 0.03 or 0.08
   local dir
   if GAME.input:hit_with_repeat('du', delay, autofire) then
      dir = 'u'
   elseif GAME.input:hit_with_repeat('dd', delay, autofire) then
      dir = 'd'
   elseif GAME.input:hit_with_repeat('dl', delay, autofire) then
      dir = 'l'
   elseif GAME.input:hit_with_repeat('dr', delay, autofire) then
      dir = 'r'
   end
   if dir and self.world:can_walk(self.pos, dir) then
      self.pos = self.pos + self.world.directions[dir].offset * self.world.tile_size
   end
end

return player
