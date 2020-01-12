local actor = {}

function actor:enter_state (state)
   self.state = state
   self.image.image:set_sheet(state) -- HACK: will be updated
   self.time = 0
end

function actor:update (input)
   if self.next_state then
      self:enter_state(self.next_state)
      self.next_state = nil
   end
   if self.state and self.states[self.state] then
      self.states[self.state](self)
   end

   if self.image.image:animation_is_interruptible() then
      self:act(input)
   end
   if self.image.image:animation_is_over() then
      self:enter_state('base')
   end
   self:move()
end

function actor:die ()
   self.despawn = true
--   self:enter_state('die')
end

return actor
