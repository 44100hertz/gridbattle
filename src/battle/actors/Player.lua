local img = love.graphics.newImage("img/ben.png")
local iwidth, iheight = img:getDimensions()

local sheet = animation.sheet(0, 0, 50, 60, iwidth, iheight, 2, 2)

local anim = {
   idle = {1, speed=0, length=1},
   move = {3,4, speed=0.1, length=2},
}

local idle = function (self)
   self.statetime = 0
   self.iasa = 0
   self.anim = anim.idle
end

local move = function (self, dx, dy)
   local goalx, goaly = self.x+dx, self.y+dy
   if space.occupy(self, goalx, goaly) then
      space.free(self.x, self.y)
      self.statetime = 0
      self.anim = anim.move
      self.iasa = 20
      self.x, self.y = goalx, goaly
   end
end

return {
   start = function (self)
      space.occupy(self, self.x, self.y)
      self.iasa = 0 -- actionability
      self.dx, self.dy = 0,0
      idle(self)
   end,

   update = function (self)
      if self.iasa==0 then
	 if input.du>0  then move(self, 0, -1)
	 elseif input.dd>0  then move(self, 0, 1)
	 elseif input.dl>0  then move(self, -1, 0)
	 elseif input.dr>0  then move(self, 1, 0)
	 end
      end

      self.statetime = self.statetime + 1
      if self.iasa>0 then self.iasa = self.iasa-1 end
   end,

   draw = function (self, x, y)
      local frameindex = math.floor(self.statetime * self.anim.speed) % self.anim.length
      love.graphics.draw(img, sheet[frameindex + 1],
			 x, y, 0, 1, 1, 25, 57)
   end,
}
