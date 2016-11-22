local anim = require "anim"
local battle = require "battle/battle"

local img = love.graphics.newImage("img/battle/bullet.png")
local iw, ih = img:getDimensions()

local sheet = anim.sheet(0, 0, 16, 16, iw, ih, 6)

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
      battle.signal(self, with, "damage", 40)
      self.despawn = true
   end,
}
