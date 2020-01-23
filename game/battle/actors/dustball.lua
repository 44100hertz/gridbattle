local dustball = {
   is_fighter = true,
   occupy_space = true,
   enable_mirror = false,

   movement_speed = 1/20,
   detect_distance = 0.4, -- change directions when this far from obstacle
   shoot_stop_length = 0.5, -- when shooting, pause for this long
   cooldown = 0.5, -- after shooting, move this long before attacking again
}

function dustball:init ()
   self:attach('image', 'dustball')
   self:attach('hp', 120)
   self.facing = 1
   self:set_state'move'
end

function dustball:update ()
   if self.state == 'move' then
      if self.timer:seconds() > self.cooldown and self:locate_enemy_ahead() then
         self:spawn{class = 'triangle'}
         self:set_state('shoot')
         return
      end
      local directions = {point(1,0), point(0,1), point(-1,0), point(0,-1)}
      local offset = directions[self.facing]
      if self:can_occupy(self.pos + offset * self.detect_distance) then
         self.velocity = offset * self.movement_speed
         self:move()
      else
         self.facing = 1 + (self.facing-2) % 4
      end
   elseif self.state == 'shoot' then
      if self.timer:seconds_equals(self.shoot_stop_length) then
         self:set_state'move'
      end
   end
end

return dustball
