sheet = {
   generate = function(quad_size, num_frames, img_size_x, img_size_y)
      local x, y
      local quads = {}
      for y = 0,num_frames.y do
	 quads[y+1] = {}
	 for x = 0,num_frames.x do
	    quads[y+1][x+1] =
	          love.graphics.newQuad(
		  quad_size.x*x, quad_size.y*y,
		  quad_size.x, quad_size.y,
		  img_size_x, img_size_y
	       )
	 end
      end
      return quads
   end
}
