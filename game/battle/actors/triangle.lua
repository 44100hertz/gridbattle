local triangle = {
   lifespan = 1.5,
   auto_collision = true,
}

function triangle:init ()
   self:attach('image', 'bullet')
end

function triangle:update ()
   self.velocity.x = self:mirror().x * self.timer:seconds() * 10
   self:move()
end

function triangle:collide (with)
   self:damage_once(with, 80)
   self.despawn = true
end

return triangle
