local bullet = {}

function bullet:collide (with)
   self:damage_other(with, self.damage)
   self.despawn = true
end

return bullet
