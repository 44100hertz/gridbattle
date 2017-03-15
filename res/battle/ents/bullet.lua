local ents = require "battle/ents"

local class = {
   collide_die = true,
   size = 8/64,
   start = function (self)
      self.parent.enter_state = "shoot"
   end,
}

return {
   class=class,
   variants={
      triangle = {
         img = "bullet",
         damage = 80,
         sheet = {0,0,16,16,6,1},
         lifespan = 60,
         dx = 0.01,
         z = 40,
         update = function (self)
            self.dx = self.dx * 1.1
         end,
         states = {
            idle = {
               row=1, anim = {1,2,3,4,5,6},
               speed = 5,
            },
         },
      },
      boot = {
         img="boots",
         sheet={0,0,24,16,2,1},
         lifespan=120,
         dx=0.1,
      }
   }
}
