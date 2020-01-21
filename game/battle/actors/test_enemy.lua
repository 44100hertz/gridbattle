local test_enemy = {
   is_fighter = true,
   occupy_space = true,
   noflip = true,
}

function test_enemy:init ()
   self.cooldown = 0
   local levels = ({
      [1] = {40, 'testenemy'},
      [2] = {80, 'testenemy2'}
   })
   local hp, image = unpack(levels[self.level])
   self:attach('hp', hp)
   self:attach('image', image)
   if self.level == 1 then
      self.color = {169/255.0, 53/255.0, 197/255.0}
      self.bullet = nil
   elseif self.level == 2 then
      self.color = {53/255.0, 57/255.0, 196/255.0}
      self.bullet = 'Triangle'
      self.bullet_delay = 80
   end
end

function test_enemy:die ()
   self.despawn = true
   for _ = 1,50 do
      self:spawn{
         class = 'particle',
         z = 20,
         color = self.color
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
