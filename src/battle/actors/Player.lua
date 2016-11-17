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
   self.anim = anim.idle
end

local shoot = function (self)
   self.statetime = 0
   self.anim = anim.shoot
   self.actionable = false
end

local move = function (self, dx, dy)
   self.statetime = 0
   self.anim = anim.move
   self.dx, self.dy = dx, dy
   self.actionable = false
end

return {
   start = function (self)
      self.actionable = true
      self.dx, self.dy = 0,0
      idle(self)
   end,

   update = function (self)
      if self.actionable then
	 if     input.a>0   then shoot(self)
	 elseif input.du>0  then move(self, 0, -1)
	 elseif input.dd>0  then move(self, 0, 1)
	 elseif input.dl>0  then move(self, -1, 0)
	 elseif input.dr>0  then move(self, 1, 0)
	 end
      end

      local function sign(num)
	 if num > 0 then return 1
	 elseif num == 0 then return 0
	 elseif num < 0 then return -1
	 end
      end

      if self.dx~=0 or self.dy~=0 then
	 self.x = self.x + sign(self.dx)/32
	 self.y = self.y + sign(self.dy)/32
	 self.dx = self.dx - sign(self.dx)/32
	 self.dy = self.dy - sign(self.dy)/32
	 if self.dx==0 and self.dy==0 then
	    self.actionable = true
	    idle(self)
	 end
      end

      -- Animation-based logic --
      self.statetime = self.statetime + self.anim.speed
   end,

   draw = function (self, x, y)
      local frameindex = math.floor(self.statetime) % self.anim.length
      love.graphics.draw(img, sheet[frameindex + 1],
			 x, y, 0, 1, 1, 25, 57)
   end,
}
