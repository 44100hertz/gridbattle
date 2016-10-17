--[[ Actor
A stage actor state machine and animation system

callbacks:
start = {[state]} ; what state to start in
act()             ; called each frame after iasa

Data:
{
   self.state_time    ; how far into current animation
   loop = boolean     ; [optional] enable looping
}

state = {
   strip,
   anim,         ; frame data
   length = _,   ; how long state lasts, nil = loop and always act
   iasa = _,     ; [optional] frames until actor runs "act" again
   now,          ; [optional] function for current action.
   after,        ; [optional] function for next action.
}
--]]

Actor = {}

function Actor:new (o)
   o = o or {}
   setmetatable(o, self)
   self.__index = self
   
   self.space = {x=2,y=2} -- Actor starting position
   self.side  = "left"    -- Actor starting stage side

   stage.occupy(self.space)         -- Create collision on space
   self.pos = stage.pos(self.space) -- Find the actual coords for drawing

   self.origin = {x=25,y=57}

   self.state = self.start
   self.state_time = 0
   return o
end

--[[
   Actor:update
   Done before each draw
--]]
function Actor:update (dt)
   self.state_time = self.state_time + 60*dt

   if self.state.now then
      self.state = self.state:now()
   end

   if length and self.state_time > length then
      self.state_timer = self.state_timer - length
      self.state = self.state.after or self.start
   end
   if not length or self.state_time > iasa then
      self:act()
   end

   self.frame = (self.state_time % #self.state.anim) + 1
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
