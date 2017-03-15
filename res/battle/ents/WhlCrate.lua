local ents = require "battle/ents"
local stage = require "battle/stage"

local class = {
   img="wheel_crate",
   group = "neutral",
   side = "none",
   ox=17, oy=35,
   tangible=false,
   dx=0, z = 200, dz = -5,
   damage = 4,
   start = function (self)
      self.x = self.x + (self.parent.side=="left" and 1 or -1)
   end,
   update = function (self)
      if self.dz<0 and self.z<=0 then
         local isfree, tenant = stage.isfree(self.x, self.y)
         if isfree then
            self.z = 0
            self.dz = 0
            self.tangible = true
	    self.size = 0.4
            stage.occupy(self, self.x, self.y)
         else
            ents.damage(tenant, 40)
            self.despawn = true
         end
      end
   end,
   collide = function (self, with)
      if with.dx and with.dx~=0 then
         self.dx = with.real_dx>0 and 1/16 or -1/16
         stage.free(self.x, self.y)
      end
   end,
}

return {class=class}
