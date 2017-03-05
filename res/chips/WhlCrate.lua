local actors = require "src/battle/actors"
local stage = require "src/battle/stage"

local ent = {
   img="wheel_crate",
   sheet={0,0,45,60,1,1,45,60},
   tangible=false,
   z = 200,
   dz = -5,
   ox=17, oy=35,
   start = function (self)
      self.tangible=false
      self.x = self.x + 2
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
            tenant.hp = tenant.hp - 40
            self.despawn=true
         end
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
