local class = {
   collide_die = true,
   size = 8/64,
   start = function (self)
      self.parent.enter_state = 'shoot'
   end,
}

return {
   class=class,
   variants={
      triangle = {
         img = 'bullet',
         damage = 80,
         lifespan = 60,
         dx = 0.01,
         z = 32,
         update = function (self)
            self.dx = self.dx * 1.1
         end,
      },
      boot = {
         start=false,
         img='boots',
         lifespan = 120,
         dx=0.1,
      }
   }
}
