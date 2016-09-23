sheet = {
   generate = function
	 (width, height, quads_width, quads_height, imgwidth, imgheight)
      local x_offset, y_offset = 0,0
      local output = {}
      for y_offset = 0,quads_height do
	 for x_offset = 0,quads_height do
	    output[y_offset * quads_width + x_offset + 1] =
	       love.graphics.newQuad( width*x_offset, height*y_offset,
				      width, height, imgwidth, imgheight )
	 end
      end
      return output
   end
}
