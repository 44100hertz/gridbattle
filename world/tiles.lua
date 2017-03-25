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
   start = function (new_data)
      data = new_data
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

   draw = function ()
      local draw_tile = function (x, y, index, flip)
         lg.draw(tileset.img, tileset.sheet[index], x, y, 0, flip, 1)
      end
      for _,layer in ipairs(data.layers) do
         local count = 1
         for y = 1,layer.width do
            for x = 1,layer.height do
               local index = layer.data[count]
               local flip = 1
               local flipoff = 0
               if index >= 0x80000000 then
                  index = index - 0x80000000
                  flip = -1
                  flipoff = data.tilewidth
               end
               if index > 0 then
                  depthdraw.add(
                     function (x,y) draw_tile(x+flipoff, y, index, flip) end,
                     x-y, x+y, -layer.offsety
                  )
               end
               count = count + 1
            end
         end
      end
   end,
}
