local poisdrop = {
   extends = 'throwable',
   img = 'poisdrop',
   dz = 1,
}

function poisdrop:hit_ground()
   self:apply_panel_stat('poison')
end

return poisdrop
