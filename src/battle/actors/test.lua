local battle = require "battle/battle"
local anim = require "anim"

local img = love.graphics.newImage("img/battle/testenemy.png")
local iw, ih = img:getDimensions()

local sheet = anim.sheet(0, 0, 50, 60, iw, ih, 1, 1)

return {
   group = "enemy",
   send = true, size=20/64,
   height = 40,

   start = function (self)
      self.stand = true
      battle.occupy(self, self.x, self.y, "right")
      self.hp = 100
   end,

   draw = function (self, x, y)
      love.graphics.draw(img, sheet[1], x, y, 0, 1, 1, 22, 8)
   end,

   damage = function (self, from, amount)
      self.hp = self.hp - amount
   end,
}
