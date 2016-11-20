local battle = require "battle/battle"
local animation = require "animation"

local img = love.graphics.newImage("img/battle/testenemy.png")
local iwidth, iheight = img:getDimensions()

local sheet = animation.sheet(0, 0, 50, 60, iwidth, iheight, 1, 1)

return {
   start = function (self)
      battle.occupy(self, self.x, self.y, "right")
   end,

   update = function (self)
      self.z = battle.getpanel(self.x, self.y).z +45
   end,

   draw = function (self, x, y)
      love.graphics.draw(img, sheet[1], x, y, 0, 1, 1, 22, 8)
   end,
}
