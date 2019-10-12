local lg = love.graphics

local Image = require 'src/Image'
local oop = require 'src/oop'

local img = Image.new('battle_ui')
local depthdraw = require 'src/depthdraw'
local BIT_XFLIP = 0x80000000

local Tiles = {}

function Tiles.from_data (data)
   local self = {
      data = data,
      tileset = {},
   }
   oop.instance(Tiles, self)
   local set = self.data.tilesets[1]
   self.tileset.sheet = Image.make_quads(
      0, 0, set.tilewidth, set.tileheight,
      math.floor(set.imagewidth / set.tilewidth),
      math.floor(set.imageheight / set.tileheight),
      set.imagewidth, set.imageheight
   )
   self.tileset.img = lg.newImage('res/world/testmap/map.png')
   return self
end

function Tiles:draw ()
   local draw_tile = function (x, y, index, flip)
      lg.draw(self.tileset.img, self.tileset.sheet[index], x, y, 0, flip, 1)
   end
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
end

return Tiles
