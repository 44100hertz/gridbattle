local exit = {}

function exit:collide (world, with)
   if with.type == 'player' then
      local offset = with.pos - self.pos
      world:set_map(self.name, self.properties.spawn, offset)
   end
end

return exit
