local actors = require "src/battle/actors"

return {
   img = "bullet",
   damage = 80,
   sheet = {0,0,16,16,6,1},
   collide_die = true,
   lifespan = 60,
   size = 8/64,
   states = {
      idle = {
         row=1, anim = {1,2,3,4,5,6},
         speed = 5,
      },
   },
   dx = 0.01,
   z = 40,

   update = function (self)
      self.dx = self.dx * 1.1
   end,
}
