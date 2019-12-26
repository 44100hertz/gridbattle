local bullet = {}

function bullet:start ()
   self.parent.next_state = 'shoot'
end

function bullet:collide (with)
   self:apply_damage(with, self.damage)
   self:die()
end

return bullet
