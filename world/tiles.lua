local lg = love.graphics

local image = require 'src/image'
local oop = require 'src/oop'

local BIT_XFLIP = 0x80000000

local tiles = {}

function tiles.from_data (data)
   local self = {
      data = data,
      tileset = {},
   }
   oop.instance(tiles, self)
   local set = self.data.tilesets[1]
   self.tileset.sheet = image.make_quads(
      0, 0, set.tilewidth, set.tileheight,
      math.floor(set.imagewidth / set.tilewidth),
      math.floor(set.imageheight / set.tileheight),
      set.imagewidth, set.imageheight
   )
   self.tileset.img = lg.newImage('res/world/testmap/map.png')
   return self
end

function tiles:draw ()
   for _,layer in ipairs(self.data.layers) do
      local count = 1
      for y = 1,layer.width do
         for x = 1,layer.height do
            local index = layer.data[count]
            local flip = 1
            local flipoff = 0
            if bit.band(index, BIT_XFLIP) ~= 0 then
               index = bit.bxor(index, BIT_XFLIP)
               flip = -1
               flipoff = self.data.tilewidth
            end
            lg.draw(self.tileset.img,
                    1,
--                    self.tileset.sheet[index],
                    x * self.data.tilewidth + flipoff,
                    y * self.data.tileheight,
                    0, flip, 1)
            count = count + 1
         end
      end
   end
end

return tiles
