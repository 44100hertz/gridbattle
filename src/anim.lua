-- Utility function to generate animation sheets
-- generating quads in advance puts this into load time
-- currently fairly sloppy; gets called by classes that want it

return {
   -- x,y = UL corner offset
   -- width, height = size of each frame
   -- iw, ih = image size
   sheet = function (x, y, w, h, iw, ih, numx, numy)
      local quads = {}

      numy = numy or 1
      local offy = y
      local i = 0

      for _=1,numy do
         local offx = x
         for _=1,numx do
            i = i + 1
            quads[i] = love.graphics.newQuad(
               offx, offy, w, h, iw, ih
            )
            offx = offx + w
         end
         offy = offy + h
      end

      return quads
   end
}
