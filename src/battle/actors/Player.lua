Player = Actor:new()

Player.img = love.graphics.newImage("img/ben.png")

local sheet_data = {
   size = {x=50, y=60},
   img_size = {x=100, y=600},
   strips = {
      idle =  { x=0,  y=0,   num=2, },
      move =  { x=0,  y=60,  num=2, },
      shoot = { x=0,  y=120, num=1, },
   }
}
sheet = Sheet.new(sheet_data)

local states = {
   idle = {
      strip = sheet.idle,
      anim = {1,2},
      rate = 6
   },
   move = {
      now  = Player.move,
      strip = sheet.move,
      anim = {1,2},
      length = 4,
      rate = 20
   },
   shoot = {
      now = Player.shoot,
      strip = sheet.shoot,
      anim = {1},
      length = 10,
      rate = 20,
   }
}
Player.start = states.idle

function Player:act()
   local x = self.space.x
   local y = self.space.y
   if     input.check("a")     then return self:shoot()
   elseif input.check("up")    then return self:move{x=x,   y=y-1}
   elseif input.check("down")  then return self:move{x=x,   y=y+1}
   elseif input.check("left")  then return self:move{x=x-1, y=y}
   elseif input.check("right") then return self:move{x=x+1, y=y}
   else return self.state
   end
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
   input.stale("a")
   return states.shoot
end

return Player
