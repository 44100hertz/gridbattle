local img = love.graphics.newImage("img/ben.png")
local iwidth, iheight = img:getDimensions()

local anims = {
   idle = {1,2, speed=0.3,
	   sheet=anim.strip(0, 0, 50, 60, iwidth, iheight, 2)},
   move = {1,2, speed=0.5,
	      sheet=anim.strip(0, 60, 50, 60, iwidth, iheight, 2)},
   shoot = {1,2, speed=0.5,
	    sheet=anim.strip(0, 120, 50, 60, iwidth, iheight, 1)},
}

local shoot = function (self)
   self.anim = anims.shoot
end

local move = function (self, dx, dy)
   self.anim = anims.move
   self.moveto = {x=self.x+self.dx, x=self.y+self.dy}
   self.dx, self.dy = dx/32, dy/32
end

return {
   start = function (self)
      self.actionable = true
      self.anim = anims.idle
      self.statetime = 0
   end,

   update = function (self)
      if     input.a   then shoot(self)
      elseif input.du  then move(self, 0, -1)
      elseif input.dd  then move(self, 0, 1)
      elseif input.dl  then move(self, -1, 0)
      elseif input.dr  then move(self, 1, 0)
      end
      if self.moveto then
	 self.x = self.pos.x + self.dx
	 self.y = self.pos.y + self.dy
	 if self.x==self.moveto.x and self.y==self.moveto.y then
	    self.moveto = false
	    self.dx, self.dy = 0, 0
	 end
      end
      self.statetime = self.statetime + self.anim.speed
   end,

   draw = function (self, x, y)
      local frame = anim.frame(self.anim, 0) or anims.idle.sheet[1]
      love.graphics.draw(img, frame, x, y, 0, 1, 1, 25, 57)
   end,
}
