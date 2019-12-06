local image = require 'src/image'
local oop = require 'src/oop'
local point = require 'src/point'

local BIT_XFLIP = 0x80000000

local tiles = oop.class()

function tiles:init (data, path)
   self.view_size = point(320, 192)
   self.data = data
   self.base_dir = path:gsub('[^/]+$', '/')
   self.tileset = {}
   local set = self.data.tilesets[1]
   local imgpath = self.base_dir .. set.image
   self.tileset.img = love.graphics.newImage(imgpath)
   self.tileset.sheet = image.make_quads(
      0, 0, set.tilewidth, set.tileheight,
      math.floor(set.imagewidth / set.tilewidth),
      math.floor(set.imageheight / set.tileheight),
      set.imagewidth, set.imageheight
   )
   self.batch = love.graphics.newSpriteBatch(self.tileset.img, 1000)
end

function tiles:draw (scroll_pos)
   local border_size = (GAME.size - self.view_size) * 0.5
   local offset = -scroll_pos + border_size
   love.graphics.translate(offset:unpack())
   -- iteration boundaries
   local tile_size = point(self.data.tilewidth, self.data.tileheight)
   local lower = (scroll_pos / tile_size):floor()
   local count = (self.view_size / tile_size):floor()
   local upper = lower + count
   for _,layer in ipairs(self.data.layers) do
      if layer.type == 'tilelayer' then
         for y = lower.y, upper.y do
            for x = lower.x, upper.x do
               local tile = layer.data[x + (y-1) * layer.width]
               if tile and tile > 0 then
                  local flip = 1
                  local flipoff = 0
                  if bit.band(tile, BIT_XFLIP) ~= 0 then
                     tile = bit.bxor(tile, BIT_XFLIP)
                     flip = -1
                     flipoff = self.data.tilewidth
                  end
                  self.batch:add(self.tileset.sheet[tile],
                                 x * self.data.tilewidth + flipoff,
                                 y * self.data.tileheight,
                                 0, flip, 1)
               end
            end
         end
      end
   end
   love.graphics.draw(self.batch)
   self.batch:clear()
end

return tiles
