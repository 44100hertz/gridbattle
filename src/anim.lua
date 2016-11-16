anim = {
   strip = function (x, y, width, height, iwidth, iheight, num)
      local quads = {}

      local offsetx = x
      for i=1,num do
	 quads[i] = love.graphics.newQuad(
	    offsetx, y, width, height, iwidth, iheight
	 )
	 offsetx = offsetx + width
      end

      return quads
   end,

   frame = function (anim, time)
      local frame = math.floor(time)+1
      return anim[time] and anim[sheet[time]] or nil
   end
}
