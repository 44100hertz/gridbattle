local image = require 'src/image'
local oop = require 'src/oop'
local point = require 'src/point'

local BIT_XFLIP = 0x80000000

local tiles = oop.class()

function tiles:init (map, path)
   self.map = map
   self.tile_size = point(self.map.tilewidth, self.map.tileheight)

   self.set = self.map.tilesets[1]
   local imgpath = path .. self.set.image
   self.set.texture = love.graphics.newImage(imgpath)
   self.set.sheet = image.make_quads(
      0, 0, self.set.tilewidth, self.set.tileheight,
      math.floor(self.set.imagewidth / self.set.tilewidth),
      math.floor(self.set.imageheight / self.set.tileheight),
      self.set.imagewidth, self.set.imageheight)

   -- Create a more convenient lookup table for tile properties.
   self.tile_properties = {}
   for i,tile in ipairs(self.set.tiles) do
      self.tile_properties[i+1] = tile
   end
end

function tiles:add_tile_actors (actors)
   for layer_index,layer in ipairs(self.map.layers) do
      if layer.type == 'tilelayer' then
         for index,tile in ipairs(layer.data) do
            local data = self.tile_properties[tile]
            if data and data.type then
--               print(data.type, self:index_to_xy(index))
               local actor = {}
               actor.is_tile = true
               actor.tile = tile
               actor.layer = layer_index
               actor.pos = (point(self:index_to_xy(index))) * self.tile_size
               actor.shape = 'point'
               actor.type = data.type
               actor.properties = data.properties
               actors:add(actor)
            end
         end
      end
   end
end

function tiles:xy_to_index(x, y)
   return x + y * self.map.width + 1
end

function tiles:index_to_xy (index)
   index = index - 1
   return (index % self.map.width), math.floor(index / self.map.width)
end

function tiles:data (x,y)
   local tile = self.map.layers[1].data[self:xy_to_index(x,y)]
   return tile and self.tile_properties[tile]
end

function tiles:properties (x, y)
   local data = self:data(x,y)
   return data and data.properties
end

function tiles:walkable (x, y)
   local props = self:properties(x, y)
   return props and props.walkable
end

function tiles:set_tile_graphics(x, y, layer, id)
   local index = self:xy_to_index(x, y)
   self.map.layers[layer].data[index] = id
end

function tiles:draw (scroll_pos, view_size)
   -- iteration boundaries
   local lower = (scroll_pos / self.tile_size):floor()+1
   local count = (view_size / self.tile_size):floor()
   local upper = lower + count

   for _,layer in ipairs(self.map.layers) do
      if layer.type == 'tilelayer' then
         for y = lower.y, upper.y do
            for x = lower.x, upper.x do
               local tile = layer.data[self:xy_to_index(x,y)]
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
                  love.graphics.draw(self.set.texture,
                                     self.set.sheet[tile],
                                     x * self.map.tilewidth + flipoff,
                                     y * self.map.tileheight,
                                     0, flip, 1)
               end
            end
         end
      end
   end
end

return tiles
