local battle = require "battle/battle"
local animation = require "animation"

local img = love.graphics.newImage("img/battle/testenemy.png")
local iwidth, iheight = img:getDimensions()

local sheet = animation.sheet(0, 0, 50, 60, iwidth, iheight, 1, 1)

return {
   group = "enemy",
   recv = true,
   start = function (self)
      battle.occupy(self, self.x, self.y, "right")
      self.hp = 100
   end,

   update = function (self)
      self.z = battle.getpanel(self.x, self.y).z +45
   end,

   draw = function (self, x, y)
      love.graphics.draw(img, sheet[1], x, y, 0, 1, 1, 22, 8)
   end,

   collide = function (self, with)
      self.hp = self.hp - 1
   end
}
