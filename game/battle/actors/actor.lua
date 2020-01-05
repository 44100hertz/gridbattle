local actor = {}

function actor:enter_state (state)
   self.state = self.states[state]
   self.image.image:set_sheet(state) -- HACK: will be updated
   self.time = 0
end

function actor:update (input)
   if self.next_state then
      self:enter_state(self.next_state)
      self.next_state = nil
   end
   if self.state then self:state() end

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
