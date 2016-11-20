local animation = require "animation"
local input = require "input"
local battle = require "battle/battle"
local bullet = require "battle/actors/bullet"

local img = love.graphics.newImage("img/battle/ben.png")
local iwidth, iheight = img:getDimensions()

local sheet = animation.sheet(0, 0, 50, 60, iwidth, iheight, 2, 3)

local states = {
   idle = {
      anim = {1, speed=0},
      iasa = 0,
   },
   move = {
      anim = {3,4, speed=0.5},
      iasa = 12,
      length = 22,
      update = function (self)
	 if self.statetime == 10 then
	    self.x, self.y = self.goalx, self.goaly
	 end
      end,
   },
   shoot = {
      anim = {5, speed=0},
      iasa = 30,
      length = 30,
      update = function (self)
	 if self.statetime == 10 then
	    battle.addactor({class=bullet, x=self.x+0.3, y=self.y, z=40})
	 end
      end
   }
}

local loadstate = function (self, state)
   self.state = state
   self.statetime = 0
   self.anim = state.anim
end

local move = function  (self, dx, dy)
   local goalx, goaly = self.x+dx, self.y+dy
   if battle.occupy(self, goalx, goaly, "left") then
      self.goalx, self.goaly = goalx, goaly
      battle.free(self.x, self.y)
      loadstate(self, states.move)
   end
end

local shoot = function (self)
   loadstate(self, states.shoot)
end

return {
   height=52,
   start = function (self)
      battle.occupy(self, self.x, self.y)
      loadstate(self, states.idle)
   end,

   update = function (self)
      if self.statetime >= self.state.iasa then
	 if input.a > 0 then shoot(self) end
	 if input.du>0  then move(self, 0, -1)
	 elseif input.dd>0  then move(self, 0, 1)
	 elseif input.dl>0  then move(self, -1, 0)
	 elseif input.dr>0  then move(self, 1, 0)
	 end
      end

      if self.statetime == self.state.length then
	 loadstate(self, states.idle)
      end

      if self.state.update then self.state.update(self) end
      self.statetime = self.statetime + 1

      self.z = battle.getpanel(self.x, self.y).z + 55
   end,

   draw = function (self, x, y)
      local frameindex =
	 math.floor(self.statetime * self.anim.speed)
	 % #self.anim
      local frame = sheet[self.state.anim[frameindex + 1]]
      love.graphics.draw(img, frame, x, y, 0, 1, 1, 25, 5)
   end,
}
