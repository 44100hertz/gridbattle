local poisdrop = {
   auto_collision = true,
   neutral = true,
}

function poisdrop:init ()
   self.lifespan = 10.0
   self:attach('image', 'poisdrop')
   self:spawn{class = 'throw_animation', offset = point(3,0)}
end

function poisdrop:collide (with)
   self:damage_continuously(with, 10.0)
end

return poisdrop
