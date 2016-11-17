local img = love.graphics.newImage("img/ben.png")
local iwidth, iheight = img:getDimensions()

local sheet = animation.sheet(0, 0, 50, 60, iwidth, iheight, 2, 2)

local anim = {
   idle = {1, speed=0},
   move = {3,4, speed=0.1},
   shoot = {5,6, speed=0.5},
}

local idle = function (self)
   self.statetime = 0
   self.anim = anim.idle
end

local shoot = function (self)
   self.statetime = 0
   self.anim = anim.shoot
end

local move = function (self, dx, dy)
   self.statetime = 0
   self.anim = anim.move
   self.moveto = {x=self.x+self.dx, x=self.y+self.dy}
   self.dx, self.dy = dx/32, dy/32
end

return {
   start = function (self)
      self.actionable = true
      idle(self)
   end,

   update = function (self)
      if     input.a>0   then shoot(self)
      elseif input.du>0  then move(self, 0, -1)
      elseif input.dd>0  then move(self, 0, 1)
      elseif input.dl>0  then move(self, -1, 0)
      elseif input.dr>0  then move(self, 1, 0)
      end
      if self.moveto then
	 self.x = self.pos.x + self.dx
	 self.y = self.pos.y + self.dy
	 if self.x==self.moveto.x and self.y==self.moveto.y then
	    self.moveto = false
	    self.dx, self.dy = 0, 0
	 end
      end

      -- Animation-based logic --
      self.statetime = self.statetime + self.anim.speed
      local frameindex = math.floor(self.statetime)
      if anim.loop then frameindex = frameindex % (anim.loop-1) end
      if not sheet[self.anim[frameindex+1]] then idle(self) end
   end,

   draw = function (self, x, y)
      love.graphics.draw(img, sheet[self.anim[math.floor(self.statetime+1)]],
			 x, y, 0, 1, 1, 25, 57)
   end,
}
