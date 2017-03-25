local lg = love.graphics
local tiles = require "world/tiles"
local depthdraw = require "src/depthdraw"

return {
   start = function ()
      local data = dofile("res/world/testmap/map1.lua")
      tiles.start(data)
      _G.GAME.xscale = data.tilewidth / 2
      _G.GAME.yscale = data.tileheight / 2
      _G.GAME.xoff = 0
      _G.GAME.yoff = 0
   end,

   update = function (_, input)
      if input.du>0 then _G.GAME.yoff = _G.GAME.yoff + 1 end
      if input.dd>0 then _G.GAME.yoff = _G.GAME.yoff - 1 end
      if input.dl>0 then _G.GAME.xoff = _G.GAME.xoff + 1 end
      if input.dr>0 then _G.GAME.xoff = _G.GAME.xoff - 1 end
      if input.b==1 then (require "src/scene").pop() end
   end,

   draw = function ()
      lg.clear(0,0,0)
      tiles.draw()
      depthdraw.draw()
   end,
}
