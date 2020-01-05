local navi = {
   extends = 'actor',
   states = {},
}

function navi.states:move ()
   if not self:is_panel_free(self.goal) then
      self.next_state = 'base'
   end
   if self.time == 5 then
      self:free_panel()
      self.pos = self.goal
      self:occupy_panel()
   end
end

return navi
