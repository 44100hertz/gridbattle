--[[ Actor
A stage actor state machine and animation system

machine functions:
   start()  ; reset to a neutral state, e.g. idle
   update() ; run one frame
   draw()   ; draw current state, does not move anything forward
   act()    ; do something based on AI, RNG, user input, etc.

format:
   self.sheet         ; Required. Where to draw from.
   self.frame         ; [internal] current frame index
   self.state_time    ; [internal] how far into current animation
   self.frame_time    ; [internal] how far into current strip frame
   self.state = {
       anim,         ; How to draw/time this state. see animation format below
       now,          ; [optional] function for current action. nil = [do nothing]
       after,        ; [optional] function for next action. nil = start.
   }
   self.anim = {
       strip = _,               ; what strip to play; sheet.x, etc.
       timing = {_,_,...},      ; length of each frame
       TODO: order = {_,_,...},       ; [optional] what order to play frames in
       length = _,              ; [optional] when to enter next state.
       loop = true              ; [optional] enable looping
       iasa = _,                ; [optional] frames until actor can act again
   }
--]]

Actor = {}

function Actor:new (o)
   o = o or {}
   setmetatable(o, self)
   self.__index = self
   
   -- Init values
   self.space = {x=2,y=2} -- Actor starting position
   self.side  = "left"    -- Actor starting stage side
   self.speed = 1         -- State speed

   -- Init actions
   stage.occupy(self.space)         -- Create collision on space
   self.pos = stage.pos(self.space) -- Find the actual coords for drawing

   -- TODO: where to put origin data? In sheet?
   self.origin = {x=25,y=57}

   -- Init state machine
   self.state = { now = self.start }
   self.frame = 1
   self.state_time = 0
   self.frame_time = 0

   return o
end


-- TODO: write code for when changing states
-- and separate code for when running
--[[
   Actor:update
   Done before each draw
--]]
function Actor:update (dt)
   -- March time forward
   self.state_time = self.state_time + self.speed*60*dt
   self.frame_time = self.frame_time + self.speed*60*dt

   -- Run current state, update if returned
   if self.state.now then
      self.state = self.state:now()
   end

   -- Go through animations
   local length = self.state.anim.length
   local iasa = self.state.anim.iasa
   if length and not iasa then iasa = length-1 end
   -- If animation ended
   if length and self.state_time > length then
      self.state = self.state.after or self.start()
   end
   -- if animation interruptible
   if not iasa or self.state_time > iasa then
      self:act()
   end

   -- Go through frames
   local anim = self.state.anim

   if self.frame_time > anim.timing[self.frame] then
      self.frame_time = self.frame_time - anim.timing[self.frame]
      self.frame = self.frame + 1
      if anim.loop and not anim.timing[self.frame] then
	 self.frame_time = self.frame_time - length
	 self.frame = 1
      end
   end
end

function Actor:draw ()
   love.graphics.draw(
      self.img,
      self.state.anim.strip[self.frame],
      self.pos.x, self.pos.y,
      0, 1, 1,
      self.origin.x, self.origin.y
   )
end

return Actor
