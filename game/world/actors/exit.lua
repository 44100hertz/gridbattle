local exit = {}

function exit:custom_init ()
   self.key = 'd' .. self.properties.direction
end

function exit:collide (with)
   if with.type == 'player' and GAME.input:hit(self.key) then
      print('Should exit to:', self.name)
   end
end

return exit
