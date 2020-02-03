local wcrate = {
   land_damage = 40,
   roll_damage = 40,

   neutral = true,
   auto_collision = true,
   occupy_space = true,
}

function wcrate:init ()
   self:attach('hp', 1000, {hidden = true})
   self:attach('image', 'wheel_crate')
   self:spawn{class = 'fall_animation'}
   self.side = self -- All others are my enemy!
end

function wcrate:update ()
   -- Roll off stage
   if self.pos.x < 0 or self.pos.x > self.battle.num_panels.x+1 then
      self:die()
   end
   self:move()
end

function wcrate:collide (with)
   if self.velocity.x == 0 then
      self.velocity = point(2,0) * with:mirror()
   else
      self:damage_continuously(with, self.roll_damage)
   end
end

return wcrate
