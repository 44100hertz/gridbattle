local ents = require "battle/ents"

local ent = {
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

   start = function (self)
      self.parent.enter_state = "shoot"
   end,
   update = function (self)
      self.dx = self.dx * 1.1
   end,
}

return {
   desc={"Shoot out",
         "some triangle."},
   ent=ent,
}
