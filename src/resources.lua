local rdr = _G.RDR
local image = require "SDL.image"

local imgstore

clear = function ()
   imgstore = {}
end

clear()

return {
   getimage = function (path)
      local w,h
      if not imgstore[path] then
         img = image.load(path)
         w,h = img:getSize()
         imgstore[path] = rdr:createTextureFromSurface(img)
      end
      return imgstore[path], w, h
   end,
}
