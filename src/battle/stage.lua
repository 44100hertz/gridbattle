local img = love.graphics.newImage("img/stage.png")
local iwidth,iheight = img:getDimensions()

local strips = {
   left =  anim.strip(0, 0, 40, 40, iwidth, iheight, 2),
   right =  anim.strip(0, 40, 40, 40, iwidth, iheight, 2),
}

return {
   walkable = true,
   draw = function (self, x, y)
      local frame = self.side=="left" and strips.left[2] or strips.right[2]
      love.graphics.draw(img, frame, x, y, 0, 1, 1, 20, 12)
   end,
}
