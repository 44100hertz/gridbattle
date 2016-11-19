local img = love.graphics.newImage("img/testenemy.png")
local iwidth, iheight = img:getDimensions()

local sheet = animation.sheet(0, 0, 50, 60, iwidth, iheight, 1, 1)

return {
   side = "right",
   start = function (self)
      space.occupy(self, self.x, self.y)
   end,

   update = function (self)
   end,

   draw = function (self, x, y)
      love.graphics.draw(img, sheet[1], x, y, 0, 1, 1, 22, 51)
   end,
}
