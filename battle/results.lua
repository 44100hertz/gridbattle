local image = require "SDL.image"
local rdr = _G.RDR
local scene = require "src/scene"
local img

return {
   transparent = true,
   open = true,

   start = function (result)
      img = rdr:createTextureFromSurface(image.load(PATHS.battle .. result .. ".png"))
   end,

   update = function (_, input)
      if input[1].a==1 then
	 scene.pop()
	 scene.pop()
      end
   end,

   draw = function ()
      rdr:copy(img)
   end,
}
