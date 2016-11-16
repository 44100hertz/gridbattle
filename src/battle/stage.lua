local img = love.graphics.newImage("img/stage.png")
local iwidth,iheight = img:getDimensions()

strips = {
   left =  Sheet.new{x=0, y=0, iwidth=iwidth, iheight=iheight num=2},
   right = Sheet.new{x=0, y=40, iwidth=iwidth, iheight=iheight, num=2},
}

platform = {
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

return platform
