local throw_animation = {}

function throw_animation:init ()
   self.lifespan = 1.0
   self.parent.remove_from_battle = true
   self.parent.velocity = self:mirror() * point(3,0)
end

function throw_animation:update ()
   self.parent.dz = 1 + self.timer:seconds() * -2
   self.parent:move()
end

function throw_animation:draw ()
   self.parent:draw()
end

function throw_animation:die ()
   self.parent.velocity = point(0,0)
   self.parent.dz = 0
   self.parent.z = 0
   self.replace_with = self.parent
   if self.parent.after_spawn_animation then
      self.parent:after_spawn_animation()
   end
end

return throw_animation
