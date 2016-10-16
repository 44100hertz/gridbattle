assert(Actor)

local sheet = Sheet.new(require "sheets/ben")

o = {img = sheet.img}
Player = Actor:new(o)

local anims = {
   idle = {
      strip = sheet.idle,
      timing = {5,5},
      length = 10,
      loop = true,
   },
   move = {
      strip = sheet.move,
      timing = {5,5},
      length = 10,
   },
   shoot = {
      strip = sheet.shoot,
      timing = {10},
      length = 10,
   }
}

local states = {
   idle = {
      anim = anims.idle,
   },
   move = {
      anim = anims.move,
      now = Player.move,
   },
   shoot = {
      anim = anims.shoot,
      now = Player.shoot,
   }
}

function Player:act()
   if     input.check("a")     then self:shoot()
   elseif input.check("up")    then self:move{x=self.space.x,   y=self.space.y-1}
   elseif input.check("down")  then self:move{x=self.space.x,   y=self.space.y+1}
   elseif input.check("left")  then self:move{x=self.space.x-1, y=self.space.y}
   elseif input.check("right") then self:move{x=self.space.x+1, y=self.space.y}
   end
end

function Player:start()
   return states.idle
end

function Player:move(space_goal)
   input.stale("pad") -- Require a re-press
   if stage.canGo(space_goal, self.side) then
      stage.free(self.space)
      stage.occupy(space_goal)
      -- TODO: make moving not instant
      self.space = space_goal
      self.pos = stage.pos(self.space)
      return states.move
   else
      return self.state
   end
end

function Player:shoot()
   self.state = states.shoot
   input.stale("a")
end

return Player
