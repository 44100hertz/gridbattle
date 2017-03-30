local rdr = _G.RDR
local image = require "SDL.image"

local imgstore
local tags = {}

clear = function ()
   imgstore = {}
end

clear()

return {
   getimage = function (path, tag)
      tags[tag] = tags[tag] or {}
      tags[tag][path] = true
      local w,h
      if not imgstore[path] then
         img = image.load(path)
         w,h = img:getSize()
         imgstore[path] = rdr:createTextureFromSurface(img)
      end
      return imgstore[path], w, h
   end,

   cleartag = function (tag)
      if not tags[tag] then return end
      for k,_ in pairs(tags[tag]) do print(k) imgstore[k] = nil end
   end,
}
