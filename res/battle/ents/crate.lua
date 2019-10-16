return {
   class={
      dx=0, z = 200, dz = -5,
      side = 'none',
      tangible = false,
      spawn_offset = 1,
      hp = 1000, hide_hp = true,
      start = function (self)
         local mirror = self.parent.side=='left' and 1 or -1
         self.x = self.x + self.spawn_offset * mirror
         self.parent.enter_state = 'shoot'
      end,
      update = function (self)
         if self.dz<0 and self.z<=0 then
            self.z = 0
            self.dz = 0
            self.tangible = true
            self.size = 20/64
            local panel = self:query_panel()
            if panel.tenant then
               self:apply_damage(panel.tenant, self.conflict_damage)
            end
         end
         if self.x < 0 or self.x > 7 then
            self.despawn = true
         end
         self:move()
      end,
   },
   variants = {
      wheeled = {
         img='wheel_crate',
         conflict_damage = 40,
         collide = function (self, with)
            if self.z == 0 then
               self:apply_damage(with, 4)
            end
            if with.dx and with.dx~=0 then
               self.dx = with.real_dx>0 and 1/16 or -1/16
               self.tangible = false
            end
         end,
      }
   }
}
