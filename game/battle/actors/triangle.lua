local triangle = {
   lifespan = 1.0,
}

function triangle:init ()
   self:attach('image', 'bullet')
end

function triangle:update ()
   self.velocity.x = self.timer:seconds() * 0.3
   self:move()
end

function triangle:collide (with)
   self:damage_other(with, 80)
   self.despawn = true
end

return triangle
