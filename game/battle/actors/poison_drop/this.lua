local poisdrop = {
   auto_collision = true,
   neutral = true,
}

function poisdrop:init ()
   self.lifespan = 10.0
   self:attach('image', 'poisdrop', {base = {rect={0,0,16,16}, origin={8,7}}})
   self:spawn{class = 'throw_animation', offset = point(3,0)}
end

function poisdrop:collide (with)
   self:damage_continuously(with, 10.0)
end

return poisdrop
