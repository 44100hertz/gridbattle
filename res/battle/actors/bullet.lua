return {
   sheet = {0,0,16,16,6,1},
   collide_die = true,
   size = 8/64,
   states = {
      idle = {
         row=1, anim = {1,2,3,4,5,6},
         speed = 5,
      },
   },
   dx = 0.01,

   update = function (self)
      self.dx = self.dx * 1.1
      self.x = self.x + self.dx
      if self.x > 10 then self.despawn = true end
   end,
}
