local poisdrop = {
   lifespan = 60,
}

function poisdrop:init ()
   self.velocity = point(3.0/60, 0.0)
   self.dz = 1
   self.parent:enter_state('throw')
   self:attach('image', 'poisdrop')
end

function poisdrop:update ()
   self.dz = self.dz - 1/30
   self:move()
end

function poisdrop:die ()
   self.despawn = true
   self:apply_panel_stat('poison')
end

return poisdrop
