local ents = require 'battle/ents'
local class = {
   collide_die = true,
   size = 8/64,
   start = function (self)
      self.parent.enter_state = 'shoot'
   end,
   collide = function (self, with)
      ents.apply_damage(self, with, self.damage)
   end,
}

return {
   class=class,
   variants={
      triangle = {
         img = 'bullet',
         lifespan = 60,
         dx = 0.01,
         z = 32,
         damage = 80,
         update = function (self)
            self.dx = self.dx * 1.1
            self:move()
         end,
      },
      boot = {
         img='boots',
         lifespan = 120,
         damage = 40,
         dx=0.1,
      }
   }
}
