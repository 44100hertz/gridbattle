local particle = {
   gravity = 0.1,
   can_collide = false,
   auto_occupy = false,
}

function particle:start ()
   local dr = math.random() / 16 + 1/32
   local theta = math.random() * 2 * math.pi
   self.dx = dr * math.sin(theta)
   self.dy = dr * math.cos(theta)
   self.dz = math.random() * 5
end

function particle:update ()
   self.dz = self.dz - self.gravity
   if self.z < -200 then self.despawn = true end
   self:move()
end

function particle:draw (x, y, draw_shadow)
   if draw_shadow then
      return
   end
   love.graphics.setColor(unpack(self.color))
   love.graphics.circle('fill', x, y, math.max(0, 5 + self.z*5/200), 4)
   love.graphics.setColor(1.0, 1.0, 1.0, 1.0)
end

return particle
