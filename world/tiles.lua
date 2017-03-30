local SDL = require "SDL"
local rdr = _G.RDR

local depthdraw = require "src/depthdraw"
local resources = require "src/resources"
local data
local img
local band = bit.band
local bxor = bit.bxor
local bor = bit.bor
local BIT_XFLIP = 0x80000000

local w,h, numx

return {
   start = function (_data)
      data = _data
      local set = data.tilesets[1]
      w,h = set.tilewidth, set.tileheight
      numx = math.floor(set.imagewidth / data.tilewidth)
      img = resources.load("res/world/testmap/map.png", "world")
   end,

   draw = function ()
      local draw_tile = function (x, y, index, flip)
         local tx, ty = index % numx, math.floor(index / numx)
         rdr:copyEx{texture=img,
                    source = {x=w*tx, y=h*ty, w=w, h=h},
                    destination = {x=x, y=y, w=w, h=h},
                    flip=flip,
         }
      end
      for _,layer in ipairs(data.layers) do
         local count = 1
         for y = 1,layer.width do
            for x = 1,layer.height do
               local index = layer.data[count]
               local flip = 0
               local flipoff = 0
               if index > 0 then
                  if band(index, BIT_XFLIP) ~= 0 then
                     index = bxor(index, BIT_XFLIP)
                     flip = SDL.rendererFlip.Horizontal
                  end
                  depthdraw.add(
                     function (x,y) draw_tile(x, y, index-1, flip) end,
                     x-y, x+y, -layer.offsety
                  )
               end
               count = count + 1
            end
         end
      end
   end,

   exit = function ()
      resources.cleartag"world"
   end
}
