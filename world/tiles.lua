local image = require 'src/image'
local oop = require 'src/oop'
local point = require 'src/point'

local BIT_XFLIP = 0x80000000

local tiles = oop.class()

function tiles:init (map, path)
   self.map = map
   local tsx_path = self.map.tilesets[1].filename
   local tileset_path = path .. tsx_path:gsub('.tsx$', '.lua')

   self.set = dofile(tileset_path)
   local imgpath = path .. self.set.image
   self.set.texture = love.graphics.newImage(imgpath)
   self.set.sheet = image.make_quads(
      0, 0, self.set.tilewidth, self.set.tileheight,
      math.floor(self.set.imagewidth / self.set.tilewidth),
      math.floor(self.set.imageheight / self.set.tileheight),
      self.set.imagewidth, self.set.imageheight)
   self.batch = love.graphics.newSpriteBatch(self.set.texture, 1000)

   -- Create a more convenient lookup table for tile properties.
   self.tile_properties = {}
   for i,tile in ipairs(self.set.tiles) do
      self.tile_properties[tile.id] = tile.properties
   end
end

function tiles:index(x, y)
   return x + (y-1) * self.map.width
end

function tiles:properties (x, y)
   local tile = self.map.layers[1].data[self:index(x,y)]
   return tile and self.tile_properties[tile]
end

function tiles:walkable (x, y)
   local props = self:properties(x, y)
   return props and props.walkable
end

function tiles:draw (scroll_pos, view_size)
   -- iteration boundaries
   local tile_size = point(self.map.tilewidth, self.map.tileheight)
   local lower = (scroll_pos / tile_size):floor()+1
   local count = (view_size / tile_size):floor()
   local upper = lower + count

   for _,layer in ipairs(self.map.layers) do
      if layer.type == 'tilelayer' then
         for y = lower.y, upper.y do
            for x = lower.x, upper.x do
               local tile = layer.data[self:index(x,y)]
               if x > 0 and x <= layer.width and
                  y > 0 and y <= layer.height and
                  tile > 0
               then
                  local flip = 1
                  local flipoff = 0
                  if bit.band(tile, BIT_XFLIP) ~= 0 then
                     tile = bit.bxor(tile, BIT_XFLIP)
                     flip = -1
                     flipoff = self.map.tilewidth
                  end
                  self.batch:add(self.set.sheet[tile],
                                 (x-1) * self.map.tilewidth + flipoff,
                                 (y-1) * self.map.tileheight,
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
