local tiles = require 'world/tiles'
local oop = require 'src/oop'

local lg = love.graphics
local world = {}

function world.from_map_path (path)
   local data = dofile(path)
   local self = {
      tiles = tiles.from_data(data),
      x = 0,
      y = 0,
   }
   oop.instance(world, self)
   return self
end

function world:update (input)
   input = input[1]
   if input.du>0 then self.y = self.y + 1 end
   if input.dd>0 then self.y = self.y - 1 end
   if input.dl>0 then self.x = self.x + 1 end
   if input.dr>0 then self.x = self.x - 1 end
   if input.b==1 then (require 'src/scene').pop() end
end

function world:draw ()
   lg.clear(0,0,0)
   lg.translate(self.x, self.y)
   self.tiles:draw()
end

return world
