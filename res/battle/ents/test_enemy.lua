local test_enemy = {
   tangible = true,
   size=20/64,
   noflip = true,
   cooldown = 0,
}

function test_enemy:after_image_load ()
   self.image.yscale = 0.5
end

function test_enemy:start ()
   assert(self.level)
   if self.level == 1 then
      self.img = 'testenemy'
      self.max_hp = 40
      self.color = {169/255.0, 53/255.0, 197/255.0}
      self.bullet = nil
   elseif self.level == 2 then
      self.img = 'testenemy2'
      self.max_hp = 80
      self.color = {53/255.0, 57/255.0, 196/255.0}
      self.bullet = 'Triangle'
      self.bullet_delay = 80
   end
end

function test_enemy:die ()
   self.despawn = true
   for _ = 1,50 do
      self:spawn{
         name = 'particle',
         x=self.x, y=self.y, z=20,
         color=self.color
      }
   end
end

function test_enemy:update ()
   if self.bullet and self:locate_enemy_ahead() and self.cooldown<1 then
      self.cooldown = self.bullet_delay
      self:use_chip(self.bullet)
   end
   self.cooldown = self.cooldown - 1
end

return test_enemy
