local triangle = {
   lifespan = 60,
}

function triangle:init ()
   self.velocity = point(0, 0)
   self:attach('image', 'bullet')
end

function triangle:update ()
   self.velocity.x = self.time * 0.005
   self:move()
end

function triangle:collide (with)
   self:damage_other(with, 80)
   self.despawn = true
end

return triangle
