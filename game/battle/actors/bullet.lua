local bullet = {}

function bullet:start ()
   self.parent.next_state = 'shoot'
end

function bullet:collide (with)
   self:damage_other(with, self.damage)
   self.despawn = true
end

return bullet
