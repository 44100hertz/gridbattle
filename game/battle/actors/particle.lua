local particle = {
   gravity = 0.1,
}

function particle:init ()
   local dr = math.random() / 16 + 1/32
   local theta = math.random() * 2 * math.pi
   self.velocity = point(math.sin(theta), math.cos(theta)) * dr
   self.dz = math.random() * 5
end

function particle:update ()
   self.dz = self.dz - self.gravity
   if self.z < -200 then self.despawn = true end
   self:move()
end

function particle:draw ()
   local x, y = self:screen_pos():unpack()
   love.graphics.setColor(unpack(self.color))
   love.graphics.circle('fill', x, y, math.max(0, 5 + self.z*5/200), 4)
   love.graphics.setColor(1.0, 1.0, 1.0, 1.0)
end

function particle:die ()
   self.despawn = true
end

return particle
