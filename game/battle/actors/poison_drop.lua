local poisdrop = {}

function poisdrop:init ()
   self.velocity = point(3.0, 0.0)
   self.lifespan = 10.0
   self:attach('image', 'poisdrop')
   self.landed = false
end

function poisdrop:update ()
   self.dz = 1 + self.timer:seconds() * -2
   if self.timer:seconds() >= 1.0 then
      self.landed = true
   else
      self:move()
   end
end

function poisdrop:collide (with)
   if self.landed then
      self:damage_other(with, 1.0/8)
   end
end

return poisdrop
