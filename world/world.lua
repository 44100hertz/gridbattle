local lg = love.graphics

local quads = require "src/quads"
local depthdraw = require "src/depthdraw"
local data
local tileset

make_1d = function (array2d)
   local array1d = {}
   local count = 1
   for _,row in ipairs(array2d) do
      for _,entry in ipairs(row) do
         array1d[count] = entry
         count = count + 1
      end
   end
   return array1d
end

return {
   start = function ()
      data = dofile("res/world/testmap/map1.lua")
      _G.GAME.xscale = data.tilewidth / 2
      _G.GAME.yscale = data.tileheight / 2
      _G.GAME.xoff = 0
      _G.GAME.yoff = 0

      local set = data.tilesets[1]
      tileset = {}
      tileset.sheet = make_1d(
         quads.sheet(
            0, 0, set.tilewidth, set.tileheight,
            math.floor(set.imagewidth / set.tilewidth),
            math.floor(set.imageheight / set.tileheight),
            set.imagewidth, set.imageheight
         )
      )
      tileset.img = lg.newImage("res/world/testmap/map.png")
   end,

   update = function (_, input)
      if input.du>0 then _G.GAME.yoff = _G.GAME.yoff + 1 end
      if input.dd>0 then _G.GAME.yoff = _G.GAME.yoff - 1 end
      if input.dl>0 then _G.GAME.xoff = _G.GAME.xoff + 1 end
      if input.dr>0 then _G.GAME.xoff = _G.GAME.xoff - 1 end
   end,

   draw = function ()
      lg.clear(0,0,0)
      for _,layer in ipairs(data.layers) do
         local count = 1
         for y = 1,layer.width do
            for x = 1,layer.height do
               local index = layer.data[count]
               if index > 0 then
                  local frame = tileset.sheet[index]
                  depthdraw.add(
                     function (x, y)
                        lg.draw(tileset.img, frame, x, y)
                     end,
                     x-y, x+y, -layer.offsety
                  )
               end
               count = count + 1
            end
         end
      end
      depthdraw.draw()
   end,
}
