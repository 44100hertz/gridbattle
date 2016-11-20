local animation = require "animation"

local img = love.graphics.newImage("img/battle/bullet.png")
local iwidth, iheight = img:getDimensions()

local sheet = animation.sheet(0, 0, 16, 16, iwidth, iheight, 6)

return {
   send=true, size=8/64,
   start = function (self)
      self.time = 0
      self.dx = 0.01
   end,

   update = function (self)
      self.time = self.time + 1
      self.dx = self.dx * 1.1
      self.x = self.x + self.dx
      if self.x > 10 then self.despawn = true end
   end,

   draw = function (self, x, y)
      local frame = sheet[math.floor(self.time / 4) % 6 + 1]
      love.graphics.draw(img, frame, x, y, 0, 1, 1, 7, 0)
   end,

   recv = function (self, with)
      self.despawn = true
   end,
}
