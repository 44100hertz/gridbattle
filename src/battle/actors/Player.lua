Actor = require "battle/actors/Actor"

Player = Actor:new()

function Player:idle()
   if     input.check("a")     then self:shoot()
   elseif input.check("up")    then self:move{x=self.space.x,   y=self.space.y-1}
   elseif input.check("down")  then self:move{x=self.space.x,   y=self.space.y+1}
   elseif input.check("left")  then self:move{x=self.space.x-1, y=self.space.y}
   elseif input.check("right") then self:move{x=self.space.x+1, y=self.space.y}
   end
end

function Player:init()
   self.state = self.idle
   self.frame = self.frames[1][1]
   self.state_timer = 0
   self:idle()
end

function Player:move(space_goal)
   input.stale("pad") -- Force button repress in order to move twice
   if stage.canGo(space_goal, self.side) then
      self.state = self.cooldown
      self.state_timer = 0
      self.frame = self.frames[2][1]

      stage.free(self.space)
      stage.occupy(space_goal)
      self.space = space_goal
      self.pos = stage.pos(self.space)
   end
end

function Player:shoot()
   input.stale("a")
   self.frame = self.frames[3][1]
   self.state = self.cooldown
   self.state_timer = 0
end

return Player
