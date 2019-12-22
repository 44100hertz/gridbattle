local enemy = {}

function enemy:update ()
end

function enemy:collide (with)
   if self.properties.battle then
      self:enter_battle(self.properties.battle)
      self.visible = false
      self.active = false
   end
end

return enemy
