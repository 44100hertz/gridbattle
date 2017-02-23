local loadstate = function (self, state)
   self.state = state
   self.time = 0
end

return {
   loadstate = loadstate,

   stateupdate = function (self)
      if self.time == self.state.length then
         loadstate(self, self.state.finish)
      end

      if self.state.update then self.state.update(self) end
      self.time = self.time + 1
   end,

   drawanimated = function (self, x, y)
      local frameindex =
         math.floor(self.time * self.state.anim.speed)
         % #self.state.anim
      local frame = self.sheet[self.state.anim[frameindex + 1]]
      love.graphics.draw(self.img, frame, x, y, 0, 1, 1, 25, 5)
   end
}
