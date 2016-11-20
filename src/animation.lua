return {
   -- x,y = UL corner offset
   -- width, height = size of each frame
   -- iwidth, iheight = image size
   sheet = function (x, y, width, height, iwidth, iheight, numx, numy)
      local quads = {}

      numy = numy or 1
      local offsety = y
      local index = 0

      for _=1,numy do
	 local offsetx = x
	 for _=1,numx do
	    index = index + 1
	    quads[index] = love.graphics.newQuad(
	       offsetx, offsety, width, height, iwidth, iheight
	    )
	    offsetx = offsetx + width
	 end
	 offsety = offsety + height
      end

      return quads
   end
}
