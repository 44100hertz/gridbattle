local input = require "src/input"
local actors = require "src/battle/actors"
local stage = require "src/battle/stage"

local states = {}
states.idle = {
   anim = {1},
   speed = 1000,
   iasa = 0,
}
states.move = {
   anim = {3,4},
   speed = 5,
   iasa = 3,
   length = 4,
   act = function (self)
      if self.time == 10 then
	 self.x, self.y = self.goalx, self.goaly
      end
   end,
   finish = states.idle,
}
states.shoot = {
   anim = {5,6},
   speed = 20,
   iasa = 2,
   length = 2,
   act = function (self)
      if self.time == 10 then
         actors.add(
            {x=self.x+0.3, y=self.y, z=40},
            require "res/battle/actors/bullet"
         )
      end
   end,
   finish = states.idle,
}

local move = function  (self, dx, dy)
   local goalx, goaly = self.x+dx, self.y+dy
   if stage.occupy(self, goalx, goaly, "left") then
      self.goalx, self.goaly = goalx, goaly
      stage.free(self.x, self.y)
      self.enter_state = states.move
   end
end

return {
   img = "res/battle/actors/ben.png",
   sheet = {0,0,50,60,2,6},
   ox = 24, oy = 54,

   act = function (self)
      if     input.a>0  then self.enter_state = states.shoot
      elseif input.du>0 then move(self, 0, -1)
      elseif input.dd>0 then move(self, 0, 1)
      elseif input.dl>0 then move(self, -1, 0)
      elseif input.dr>0 then move(self, 1, 0)
      end
   end,

   states = states,
}
