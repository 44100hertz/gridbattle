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
         w = 16, h = 16,
         lifespan = 60,
         dx = 0.01,
         z = 40,
         update = function (self)
            self.dx = self.dx * 1.1
         end,
         states = {
            idle = {
               row=0, anim = {0,1,2,3,4,5},
               speed = 5,
            },
         },
      },
      boot = {
         start=false,
         img="boots",
         w=24, h=16,
         lifespan = 120,
         dx=0.1,
      }
   }
}
