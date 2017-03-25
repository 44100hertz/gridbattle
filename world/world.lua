local lg = love.graphics
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
      if input.du>0 then tform.yoff = tform.yoff + 1 end
      if input.dd>0 then tform.yoff = tform.yoff - 1 end
      if input.dl>0 then tform.xoff = tform.xoff + 1 end
      if input.dr>0 then tform.xoff = tform.xoff - 1 end
      if input.b==1 then (require "src/scene").pop() end
   end,

   draw = function ()
      lg.clear(0,0,0)
      tiles.draw()
      depthdraw.draw()
   end,
}
