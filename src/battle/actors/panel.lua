local img = love.graphics.newImage("img/stage.png")
local iwidth,iheight = img:getDimensions()

local sheet = animation.sheet(0, 0, 40, 40, iwidth, iheight, 2, 2)

return {
   walkable = true,
   height = 8,
   draw = function (self, x, y)
      local frame = self.side=="left" and sheet[2] or sheet[4]
      love.graphics.draw(img, frame, x, y, 0, 1, 1, 20, 12)
      if self.under then love.graphics.rectangle("fill", x, y, 8, 8) end
   end,
}
