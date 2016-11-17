local img = love.graphics.newImage("img/ben.png")
local iwidth, iheight = img:getDimensions()

local sheet = animation.sheet(0, 0, 50, 60, iwidth, iheight, 2, 2)

local anim = {
   idle = {1, speed=0, length=1},
   move = {3,4, speed=0.1, length=2},
   shoot = {5,6, speed=0.5, length=2},
}

local idle = function (self)
   self.statetime = 0
   self.iasa = 0
   self.anim = anim.idle
end

local shoot = function (self)
   self.statetime = 0
   self.iasa = 10
   self.anim = anim.shoot
   self.actionable = false
end

local move = function (self, dx, dy)
   self.statetime = 0
   self.anim = anim.move
   self.iasa = 20
   self.x = self.x + dx
   self.y = self.y + dy
end

return {
   start = function (self)
      self.iasa = 0 -- actionability
      self.dx, self.dy = 0,0
      idle(self)
   end,

   update = function (self)
      if self.iasa==0 then
	 if     input.a>0   then shoot(self)
	 elseif input.du>0  then move(self, 0, -1)
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
