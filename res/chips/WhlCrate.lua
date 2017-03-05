local actors = require "src/battle/actors"
local stage = require "src/battle/stage"

local ent = {
   group = "neutral",
   img="wheel_crate",
   sheet={0,0,45,60,1,1,45,60},
   ox=17, oy=35,
   tangible=false,
   dx=0, z = 200, dz = -5,
   size = 0.4,
   start = function (self)
      self.tangible=false
      self.x = self.x + 1
   end,
   update = function (self)
      if self.dz<0 and self.z<=0 then
         local isfree, tenant = stage.isfree(self.x, self.y)
         if isfree then
            self.z = 0
            self.dz = 0
            self.tangible = true
            stage.occupy(self, self.x, self.y)
         else
            actors.damage(tenant, 40)
            self.despawn = true
         end
      end
   end,

   collide = function (self, with)
      if with.dx and with.dx > 0 then
         stage.free(self.x, self.y)
         self.damage = 40
         self.dx = 1/16
      end
   end,
}

return {
   desc=[[
Damage it
to roll
over foes.
]],
   ent=ent,
}
