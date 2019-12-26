local crate = {}

function crate:start ()
   self.hp = 1000
   self.hide_hp = true
   self.side = 0 -- Can hurt anyone
   self.spawn_offset = 1 -- Spawn distance from parent

   -- Spawn up high, in front of parent
   self.dx = 0
   self.z = 200
   self.dz = -5
   local mirror = self.parent.side==1 and 1 or -1
   self.x = self.x + self.spawn_offset * mirror

   self.parent.next_state = 'shoot'
end

function crate:update ()
   -- Land on ground
   if self.dz<0 and self.z<=0 then
      self.z = 0
      self.dz = 0
      self.size = 20/64
      local panel = self:query_panel()
      if panel.tenant then
         self:apply_damage(panel.tenant, self.land_damage)
         self:die()
      else
         self:occupy()
      end
   end

   -- Roll off stage
   if self.x < 0 or self.x > self.battle.stage.num_panels.x+1 then
      self:die()
   end
   self:move()
end

return crate
