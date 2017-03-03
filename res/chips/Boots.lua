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

local bootspawner = {
   lifetime=30,
   start = function (self)
      self.parent.enter_state = self.parent.states.shoot
   end,
   update = function (self)
      if self.time==10 then
         actors.add({x=self.x, y=self.y, z=40, frame=1}, boot)
      elseif self.time==30 then
         actors.add({x=self.x, y=self.y, z=40, frame=2}, boot)
      end
   end
}

return {
   ent=bootspawner,
}
