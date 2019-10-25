local wcrate = {
   extends = 'crate',
   img = 'wheel_crate',
   land_damage = 40,
   roll_damage = 4,
}

function wcrate:collide (with)
   if self.z == 0 then
      self:apply_damage(with, self.roll_damage)
   end
   if with.dx and with.dx~=0 then
      self.dx = with.real_dx>0 and 1/16 or -1/16
      self.tangible = false
   end
end

return wcrate
