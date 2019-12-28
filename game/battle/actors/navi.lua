local navi = {
   extends = 'actor',
   states = {},
}

function navi.states:move ()
   if not self:is_panel_free(self.goalx, self.goaly) then
      self.next_state = 'base'
   end
   if self.time == 5 then
      self:free_panel()
      self.x, self.y = self.goalx, self.goaly
      self:occupy_panel()
   end
end

return navi
