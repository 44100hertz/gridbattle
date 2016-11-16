--[[
standand format:
anim = {1,2, speed=0.5, sheet={strip or grid}}
--]]
anim = {
   strip = function (xoff, yoff, width, height, iwidth, iheight, num)
      local x
      local quads = {}
      for x = 1,num do
	 quads[x] = love.graphics.newQuad(
	    xoff + (x-1)*width, yoff,
	    width, height
	    iwidth, iheight)
      end
      return quads
   end,

   -- helper function for animations in standard format
   frame = function (anim, time)
      local frame = math.floor(time)+1
      return
	 anim[frame] and anim.sheet[anim[frame]]
	 or nil -- avoid index errors
   end
}

return sheet
