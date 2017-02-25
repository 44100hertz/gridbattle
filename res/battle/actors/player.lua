local input = require "src/input"
local battle = require "src/battle/battle"

local states = {}
states.idle = {
   anim = {1, speed=0},
   iasa = 0,
}
states.move = {
   anim = {3,4, speed=0.2},
   iasa = 12,
   length = 22,
   update = function (self)
      if self.time == 10 then
	 self.x, self.y = self.goalx, self.goaly
      end
   end,
   finish = states.idle,
}
states.shoot = {
   anim = {5,6, speed=0.05},
   iasa = 25,
   length = 30,
   update = function (self)
      if self.time == 10 then
         battle.addactor(
            {x=self.x+0.3, y=self.y, z=40},
            require "res/battle/actors/bullet"
         )
      end
   end,
   finish = states.idle,
}

local move = function  (self, dx, dy)
   local goalx, goaly = self.x+dx, self.y+dy
   if battle.occupy(self, goalx, goaly, "left") then
      self.goalx, self.goaly = goalx, goaly
      battle.free(self.x, self.y)
      self.enter_state = states.move
   end
end

return {
   height=52,
   img = "res/battle/actors/ben.png",
   sheet = {0,0,50,60,3},
   start = function (self)
      self.stand = true
      battle.occupy(self, self.x, self.y)
      self.state = states.idle
      self.time = 0
   end,

   update = function (self)
      if self.time >= self.state.iasa then
         if input.a > 0 then self.enter_state = states.shoot end
         if input.du>0  then move(self, 0, -1)
         elseif input.dd>0  then move(self, 0, 1)
         elseif input.dl>0  then move(self, -1, 0)
         elseif input.dr>0  then move(self, 1, 0)
         end
      end
   end,

   draw = function (self)
      -- local frameindex =
      --    math.floor(self.time * self.state.anim.speed)
      --    % #self.state.anim
      -- local frame = self.sheet[self.state.anim[frameindex + 1]]
      love.graphics.draw(self.image, x, y, 0, 1, 1, 25, 5)
   end,
}
