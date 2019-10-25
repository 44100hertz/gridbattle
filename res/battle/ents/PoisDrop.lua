local poisdrop = {
   extends = 'throwable',
   img = 'poisdrop',
   z=40, dz = 1,
}

function poisdrop:hit_ground()
   self:apply_panel_stat('poison', 600)
end

return poisdrop
