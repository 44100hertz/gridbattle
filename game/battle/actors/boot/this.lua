local boot = {
   lifespan = 2.0,
   auto_collision = true,
}

function boot:init ()
   self:attach('image', 'boots', {base = {rect={0,0,24,16}, origin={11,7}, count={2,1}}})
   self.velocity.x = self:mirror().x * 6
end

function boot:collide (with)
   self:damage_once(with, 40)
   self.remove_from_battle = true
end

return boot
