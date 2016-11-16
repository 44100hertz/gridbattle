local img = love.graphics.newImage("img/stage.png")
local iwidth,iheight = img:getDimensions()

local strips = {
   left =  anim.strip(0, 0, 40, 40, iwidth, iheight, 2),
   right =  anim.strip(0, 40, 40, 24, iwidth, iheight, 2),
}

return {
   walkable = true,
   draw = function (self, x, y)
      if self.side == "left" then
	 local frame = strips.left[1]
      else
	 local frame = strips.right[1]
      end
      love.graphics.draw(img, frame, x, y, 0, 1, 1, 20, 12)
   end,
}
