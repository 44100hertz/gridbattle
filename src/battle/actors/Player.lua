Player = {}

Player.new = function (self, o, space, side)
   o = o or {}
   setmetatable(o, self)
   self.__index = self

   self.space = space or {x=2,y=2}
   self.side  = side or "left"

   stage.occupy(self.space)
   self.pos = stage.pos(self.space)

   self.origin = {x=25,y=57}

   self.state = self.start
   self.state_time = 0
   return o
end

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

local states = {}
states.idle = {
   strip = sheet.idle,
   anim = {1,2},
   rate = 6
}
states.move = {
   now  = function (self)
      print(self)
      print(self.shift.x)
      if self.shift.x then self.pos.x = self.pos.x + self.shift.x end
      if self.shift.y then self.pos.y = self.pos.y + self.shift.y end
   end,
   strip = sheet.move,
   anim = {1,2},
   length = 4,
   rate = 20
}
states.shoot = {
   now = Player.shoot,
   strip = sheet.shoot,
   anim = {1},
   length = 10,
   rate = 20,
}
Player.start = states.idle

function Player:act()
   local x = self.space.x
   local y = self.space.y
   if     input.check("a")     then return self:shoot()
   elseif input.check("up")    then return self:move{y=-1}
   elseif input.check("down")  then return self:move{y= 1}
   elseif input.check("left")  then return self:move{x=-1}
   elseif input.check("right") then return self:move{x= 1}
   else return self.state
   end
end

function Player:move(shift)
   self.shift = shift
   print(shift.x)
   input.stale("pad")

   local space_goal = {}
   space_goal.x = self.space.x + (shift.x or 0)
   space_goal.y = self.space.y + (shift.y or 0)

   if stage.canGo(space_goal, self.side) then
      stage.free(self.space)
      stage.occupy(space_goal)
      self.space = space_goal
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
