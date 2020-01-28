local boot = {
   lifespan = 2.0,
}

function boot:init ()
   self:attach('image', 'boots')
   self.velocity.x = self:mirror().x * 6
end

function boot:collide (with)
   self:damage_once(with, 40)
   self.despawn = true
end

return boot
