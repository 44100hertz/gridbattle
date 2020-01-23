local boot = {
   lifespan = 2.0,
}

function boot:init ()
   self:attach('image', 'boots')
   self.velocity.x = 0.1
end

function boot:collide (with)
   self:damage_other(with, 40)
   self.despawn = true
end

return boot
