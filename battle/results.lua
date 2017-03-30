local rdr = _G.RDR
local scene = require "src/scene"
local resources = require "src/resources"
local img

return {
   transparent = true,
   open = true,

   start = function (result)
      img = resources.getimage(_G.PATHS.battle .. result .. ".png", "battle")
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
