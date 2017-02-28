-- Utility function to generate animation sheets
-- generating quads in advance puts this into load time
-- currently fairly sloppy; gets called by classes that want it

return {
   -- x,y = UL corner offset
   -- width, height = size of each frame
   -- iw, ih = image size
   sheet = function (x, y, w, h, numx, numy, iw, ih)
      local quads = {}

      numy = numy or 1
      local offy = y

      for iy=1,numy do
         local offx = x
         quads[iy] = {}
         for ix=1,numx do
            quads[iy][ix] = love.graphics.newQuad(
               offx, offy, w, h, iw, ih
            )
            offx = offx + w
         end
         offy = offy + h
      end

      return quads
   end
}
