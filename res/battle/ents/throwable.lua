local throwable = {
   dx = 3/60,
   lifespan = 60,
}

function throwable:start ()
   self.parent.next_state = 'throw'
end

function throwable:update ()
   self.dz = self.dz - 1/20
   if self.time == 60 then
      self:hit_ground()
   end
   self:move()
end

return throwable
