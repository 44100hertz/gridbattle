local fall_animation = {}

function fall_animation:init ()
   self.lifespan = 1.0
   if not self.parent.land_damage then
      io.write('Warning: class ', self.parent.class, ' does not specify damage caused when landing on other via land_damage')
   end
   self.parent.velocity = point(0,0)
   self.parent.z = 3
   self.parent.dz = -3
   self.parent.pos = self.parent.pos + point(1, 0) * self.parent:mirror()
   self.parent.remove_from_battle = true
end

function fall_animation:update ()
   self.parent:move()
   if self.parent.z <= 0 then
      local tenant = self.battle:locate_actor(self.parent.pos)
      if tenant then
         self.parent:damage_once(tenant, self.parent.land_damage or 40)
         self.parent:die()
         self.remove_from_battle = true
      else
         self:die()
      end
   end
end

function fall_animation:draw ()
   self.parent:draw()
end

function fall_animation:die ()
   self.parent.velocity = point(0,0)
   self.parent.dz = 0
   self.parent.z = 0
   self.replace_with = self.parent
   if self.parent.after_spawn_animation then
      self.parent:after_spawn_animation()
   end
end

return fall_animation
