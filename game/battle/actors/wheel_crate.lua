local wcrate = {
   land_damage = 40,
   roll_damage = 4,
}

function wcrate:init ()
   self:attach('hp', 1000, true)
   self.side = 0 -- Can hurt anyone

   -- Spawn up high, in front of parent
   self.velocity = point(0,0)
   self.z = 200
   self.dz = -5
   self.pos = self.pos + point(1, 0) * self.parent:mirror()

   self:attach('image', 'wheel_crate')
end

function wcrate:update ()
   -- Land on ground
   if self.dz<0 and self.z<=0 then
      self.z = 0
      self.dz = 0
      self.size = 20/64
      local tenant = self.battle:locate_actor(self.pos)
      if tenant then
         self:damage_other(tenant, self.land_damage)
         self:die()
      else
         self.occupy_space = true
      end
   end

   -- Roll off stage
   if self.pos.x < 0 or self.pos.x > self.battle.num_panels.x+1 then
      self:die()
   end
   self:move()
end

function wcrate:collide (with)
   if self.velocity.x ~= 0 and self.z == 0 then
      self:damage_other(with, self.roll_damage)
   end
   if with.velocity and with.velocity.x ~= 0 then
      -- TODO: will roll the wrong way if used from right side
      self.velocity.x = with:real_velocity().x > 0 and 1/32 or -1/32
   end
end

return wcrate
