local anim = require "src/anim"
local input = require "src/input"
local battle = require "src/battle/battle"

local img = love.graphics.newImage("res/battle/actors/ben.png")
local iw, ih = img:getDimensions()

local sheet = anim.sheet(0, 0, 50, 60, iw, ih, 2, 3)

local states = {
   idle = {
      anim = {1, speed=0},
      iasa = 0,
   },
   move = {
      anim = {3,4, speed=0.2},
      iasa = 12,
      length = 22,
      update = function (self)
         if self.time == 10 then
            self.x, self.y = self.goalx, self.goaly
         end
      end,
   },
   shoot = {
      anim = {5,6, speed=0.05},
      iasa = 25,
      length = 30,
      update = function (self)
         if self.time == 10 then
            battle.addactor(
               {class=require "res/battle/actors/bullet",
		x=self.x+0.3, y=self.y, z=40}
            )
         end
      end
   }
}

local loadstate = function (self, state)
   self.state = state
   self.time = 0
end

local move = function  (self, dx, dy)
   local goalx, goaly = self.x+dx, self.y+dy
   if battle.occupy(self, goalx, goaly, "left") then
      self.goalx, self.goaly = goalx, goaly
      battle.free(self.x, self.y)
      loadstate(self, states.move)
   end
end

return {
   height=52,
   start = function (self)
      self.stand = true
      battle.occupy(self, self.x, self.y)
      loadstate(self, states.idle)
   end,

   update = function (self)
      if self.time >= self.state.iasa then
         if input.a > 0 then loadstate(self, states.shoot) end
         if input.du>0  then move(self, 0, -1)
         elseif input.dd>0  then move(self, 0, 1)
         elseif input.dl>0  then move(self, -1, 0)
         elseif input.dr>0  then move(self, 1, 0)
         end
      end

      if self.time == self.state.length then
         loadstate(self, states.idle)
      end

      if self.state.update then self.state.update(self) end
      self.time = self.time + 1
   end,

   draw = function (self, x, y)
      local frameindex =
         math.floor(self.time * self.state.anim.speed)
         % #self.state.anim
      local frame = sheet[self.state.anim[frameindex + 1]]
      love.graphics.draw(img, frame, x, y, 0, 1, 1, 25, 5)
   end,
}
