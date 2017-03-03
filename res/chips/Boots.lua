local actors = require "src/battle/actors"

local boot = {
   img="boots",
   sheet={0,0,24,16,2,1},
   damage=40,
   collide_die=true,
   lifespan=120,
   size=0.1,
   dx=0.1,
}

return {
   lifetime=30,
   update = function (self)
      if self.time==10 then
         actors.add({x=self.x, y=self.y, z=40, frame=1}, boot)
      elseif self.time==20 then
         actors.add({x=self.x, y=self.y, z=40, frame=2}, boot)
      end
   end
}
