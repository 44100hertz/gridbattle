local poisdrop = {}

function poisdrop:init ()
   self.velocity = self:mirror() * point(3.0, 0.0)
   self.lifespan = 10.0
   self:attach('image', 'poisdrop')
end

function poisdrop:update ()
   self.dz = 1 + self.timer:seconds() * -2
   if self.timer:seconds() >= 1.0 then
      self.auto_collision = true
   else
      self:move()
   end
end

function poisdrop:collide (with)
   self:damage_continuously(with, 10.0)
end

return poisdrop
