local rdr = _G.RDR

local tiles = require "world/tiles"
local depthdraw = require "src/depthdraw"
local tform = depthdraw.tform

return {
   start = function ()
      local data = dofile("res/world/testmap/map1.lua")
      tiles.start(data)
      tform.xscale = data.tilewidth / 2
      tform.yscale = data.tileheight / 2
      tform.xoff = 0
      tform.yoff = 0
   end,

   update = function (_, input)
      input = input[1]
      if input.du then tform.yoff = tform.yoff + 1 end
      if input.dd then tform.yoff = tform.yoff - 1 end
      if input.dl then tform.xoff = tform.xoff + 1 end
      if input.dr then tform.xoff = tform.xoff - 1 end
      if input.b==1 then (require "src/scene").pop() end
   end,

   draw = function ()
      rdr:clear()
      tiles.draw()
      depthdraw.draw()
   end,
}
