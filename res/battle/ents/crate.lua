local crate = {
   dx = 0,
   z = 200, dz = -5,
   side = 'none',
   tangible = false,
   spawn_offset = 1,
   hp = 1000, hide_hp = true,
}

function crate:start ()
   local mirror = self.parent.side==1 and 1 or -1
   self.x = self.x + self.spawn_offset * mirror
   self.parent.next_state = 'shoot'
end

function crate:update ()
   -- Land on ground
   if self.dz<0 and self.z<=0 then
      self.z = 0
      self.dz = 0
      self.tangible = true
      self.size = 20/64
      local panel = self:query_panel()
      if panel.tenant then
         self:apply_damage(panel.tenant, self.land_damage)
         if not panel.tenant.despawn then
            self.despawn = true
         end
      end
   end
   -- Roll off stage
   if self.x < 0 or self.x > 7 then
      self.despawn = true
   end
   self:move()
end

return crate
