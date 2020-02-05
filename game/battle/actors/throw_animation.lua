local throw_animation = {}

function throw_animation:init ()
   self.duration = self.duration or 1.0
   self.initial_height = self.initial_height or 0.5
   self.lifespan = self.duration * 2.0
   self.parent.remove_from_battle = true
   local pos = self.pos + self:mirror() * (self.offset or point(1,0))
   self:arc_to_panel(pos, self.initial_height, self.duration)
end

function throw_animation:draw ()
   self.parent.z = self.z
   self.parent.pos = self.pos
   self.parent:draw()
end

function throw_animation:land ()
   -- Prevent dual occupy -- parent actor will die if lands on another!
   if self.parent.occupy_space then
      if not self.parent.land_damage then
         io.write('Warning: class ', self.parent.class, ' does not specify damage caused when landing on other via land_damage')
      end
      local tenant = self.battle:locate_actor(self.pos)
      if tenant then
         self.parent:damage_once(tenant, self.parent.land_damage or 40)
         self.parent:die()
         self.remove_from_battle = true
         return
      end
   end
   self.parent.pos = self.pos
   self.parent:land()
   self.replace_with = self.parent
end

return throw_animation
