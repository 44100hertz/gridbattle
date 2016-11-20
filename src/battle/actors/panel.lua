local img = love.graphics.newImage("img/battle/stage.png")
local iwidth,iheight = img:getDimensions()

local sheet = animation.sheet(0, 0, 40, 40, iwidth, iheight, 2, 2)

return {
   walkable = true,
   height = 8,

   update = function (self)
      self.z = self.occupant and -10 or -8
   end,

   draw = function (self, x, y)
      local frame = self.side=="left" and sheet[1] or sheet[3]
      love.graphics.draw(img, frame, x, y, 0, 1, 1, 20, 12)
   end,
}
