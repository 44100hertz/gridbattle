local wcrate = {
   land_damage = 40,
   roll_damage = 40,

   neutral = true,
   -- enables auto_collision AND occupy_space after landing
}

function wcrate:init ()
   self:attach('hp', 1000, {hidden = true})
   self.side = self -- All others are my enemy!

   -- Spawn up high, in front of parent
   self.velocity = point(0,0)
   self.z = 3
   self.dz = -5
   self.pos = self.pos + point(1, 0) * self.parent:mirror()

   self:attach('image', 'wheel_crate')
end

function wcrate:update ()
   -- Land on ground
   if self.dz<0 and self.z<=0 then
      self.z = 0
      self.dz = 0
      local tenant = self.battle:locate_actor(self.pos)
      if tenant then
         self:damage_once(tenant, self.land_damage)
         self:die()
      else
         self.auto_collision = true
         self.occupy_space = true
         self.landed = true
      end
   end

   -- Roll off stage
   if self.pos.x < 0 or self.pos.x > self.battle.num_panels.x+1 then
      self:die()
   end
   self:move()
end

function wcrate:collide (with)
   if self.landed then
      if self.velocity.x == 0 then
         self.velocity = point(2,0) * with:mirror()
      else
         self:damage_continuously(with, self.roll_damage)
      end
   end
end

return wcrate
