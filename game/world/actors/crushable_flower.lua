local cflower = {}

function cflower:update ()
end

function cflower:collide (with)
   self:set_tile_graphics_here(self.tile+1)
   self.active = false
end

return cflower
