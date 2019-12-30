local poisdrop = {
   extends = 'throwable',
   dz = 1,
}

function poisdrop:init ()
   self.parent:enter_state('throw')
   self:attach('image', 'poisdrop')
end

function poisdrop:hit_ground()
   self:apply_panel_stat('poison')
end

return poisdrop
