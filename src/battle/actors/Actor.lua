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
   anim,         ; Current animation strip
   iasa = _,     ; [optional] frames until actor runs "act" again
   now,          ; [optional] function for current action.
   after,        ; [optional] function for next action.
}
--]]

Actor = {}

function Actor:new (o)
   o = o or {}
   assert(o.anim, "no player animation")
   assert(type(o.update)=="function", ""
   
   setmetatable(o, self)
   self.__index = self
   
   self.space = {x=2,y=2} -- Actor starting position
   self.side  = "left"    -- Actor starting stage side
   self.speed = 1         -- State speed

   stage.occupy(self.space)         -- Create collision on space
   self.pos = stage.pos(self.space) -- Find the actual coords for drawing

   self.origin = {x=25,y=57}

   self.state = { now = self.start }

   self.state_time = 0


   return o
end


-- TODO: write code for when changing states
-- and separate code for when running
--[[
   Actor:update
   Done before each draw
--]]
function Actor:update (dt)
   self.state_time = self.state_time + self.speed*60*dt

   if self.state.now then
      self.state = self.state:now()
   end

   -- Go through animations
   local length = self.state.anim.length
   local iasa = self.state.anim.iasa
   if length and not iasa then iasa = length-1 end

   if length and self.state_time > length then
      self.state = self.state.after
   end
   if not iasa or self.state_time > iasa then
      self:act()
   end

   if loop
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
