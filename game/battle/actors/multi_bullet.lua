local mbullet = {}

function mbullet:init ()
   self.lifespan = self.delay + self.num * self.period
end

function mbullet:update ()
   if self.time >= self.delay and
      (self.time-self.delay) % self.period == 0
   then
      self:make_bullet()
   end
end

return mbullet
