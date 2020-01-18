local boot = {
   lifespan = 120,
}

function boot:init ()
   self:attach('image', 'boots')
   self.velocity = point(0.1, 0)
end

function boot:collide (with)
   self:damage_other(with, 40)
   self.despawn = true
end

return boot
