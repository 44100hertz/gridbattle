local bullet = {
   collide_die = true,
   size = 8/64,
}

function bullet:start ()
   self.parent.next_state = 'shoot'
end

function bullet:collide (with)
   self:apply_damage(with, self.damage)
end

return bullet
