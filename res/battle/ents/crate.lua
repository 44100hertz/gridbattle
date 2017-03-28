local ai = require "battle/ai"
local ents = require "battle/ents"

return {
   class={
      dx=0, z = 200, dz = -5,
      side = "none",
      tangible = false,
      spawn_offset = 1,
      hp = 1000, hide_hp = true,
      start = function (self)
         local mirror = self.parent.side=="left" and 1 or -1
         self.x = self.x + self.spawn_offset * mirror
         self.parent.enter_state = "shoot"
      end,
      update = function (self)
         if self.dz<0 and self.z<=0 then
            local isfree, tenant = ai.is_panel_free(self.x, self.y)
            if isfree then
               self.z = 0
               self.dz = 0
               self.tangible = true
               self.size = 20/64
            elseif tenant then
               ents.apply_damage(self, tenant, 40)
               self.despawn = true
            else
               self.despawn = true
            end
         end
         if self.x < 0 or self.x > 7 then
            self.despawn = true
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
               self.tangible = false
            end
         end,
      }
   }
}
