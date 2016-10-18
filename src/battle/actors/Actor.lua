--[[ Actor
A stage actor state machine runner

Internal vars:
self.img - image to draw from using sheet data

State format:
state = {
   strip,        ; strip to play from
   anim,         ; frame data e.g. {0,0,0,1,2,1}
   length = _,   ; how long state lasts, nil = loop and always act
   iasa = _,     ; [optional] frames until actor runs "act" again
   now,          ; [optional] function for current action.
   after,        ; [optional] function for next action.
}
--]]

Actor = {}

--[[
   Actor:update
   Done before each draw
--]]
function Actor:update (dt)
   self.state_time = self.state_time + dt

   local length = self.state.length
   local rate = self.state.rate
   local iasa = self.state.iasa or self.state.length

   if length and self.state_time > length/rate then
      self.nextState = self.state.after or self.start
   end
   if not length or self.state_time > iasa then
      self.nextState = self:act()
   elseif self.state.now then
      self.nextState = self.state:now()
   end

   self.frame = (self.state_time * rate % #self.state.anim) + 1
end

function Actor:draw ()
   love.graphics.draw(
      self.img,
      self.state.strip[self.state.anim[math.floor(self.frame)]],
      self.pos.x, self.pos.y,
      0, 1, 1,
      self.origin.x, self.origin.y
   )
end

return Actor
