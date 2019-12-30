local throwable = {
   dx = 3/60,
   lifespan = 60,
}

function throwable:update ()
   self.dz = self.dz - 1/30
   self:move()
end

function throwable:die ()
   self.despawn = true
   self:hit_ground()
end

return throwable
