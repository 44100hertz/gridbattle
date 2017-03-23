local ents = require "battle/ents"
local stage = require "battle/stage"

return {
   class={
      dx=0, z = 200, dz = -5,
      group = "neutral",
      side = "none",
      tangible = false,
      spawn_offset = 1,
      start = function (self)
         local mirror = self.parent.side=="left" and 1 or -1
         self.x = self.x + self.spawn_offset * mirror
         self.parent.enter_state = "shoot"
      end,
      update = function (self)
         if self.dz<0 and self.z<=0 then
            local isfree, tenant = stage.isfree(self.x, self.y)
            if isfree then
               self.z = 0
               self.dz = 0
               self.tangible = true
               self.size = 20/64
               stage.occupy(self, self.x, self.y)
            else
               ents.apply_damage(tenant, self.conflict_damage)
               self.despawn = true
            end
         end
      end,
   },
   variants = {
      wheeled = {
         img="wheel_crate",
         ox=17, oy=35,
         damage = 4,
         conflict_damage = 40,
         collide = function (self, with)
            if with.dx and with.dx~=0 then
               self.dx = with.real_dx>0 and 1/16 or -1/16
               stage.free(self.x, self.y)
            end
         end,
      }
   }
}
