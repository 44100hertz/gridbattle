local navi = {
   extends = 'actor',
   tangible = true,
   size = 0.4,
   states = {},
}

function navi.states:move ()
   if not self:is_panel_free(self.goalx, self.goaly) then
      self.next_state = 'base'
   end
   if self.time == 5 then
      self:free_space(self.x, self.y)
      self.x, self.y = self.goalx, self.goaly
   end
end

return navi
