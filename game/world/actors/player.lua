local player = {}

function player:update (world)
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
   if dir and world:can_walk(self.pos, dir) then
      self.pos = self.pos + world.directions[dir].offset * world.tile_size
   end
end

function player:debug_draw (world)
   local x, y = (self.pos + world.tile_size/2):unpack()
   love.graphics.circle('fill', x, y, 6)
end

return player
