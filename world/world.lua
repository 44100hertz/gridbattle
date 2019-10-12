local tiles = require 'world/tiles'
local depthdraw = require 'src/depthdraw'
local oop = require 'src/oop'

local lg = love.graphics
local tform = depthdraw.tform

local world = {}

function world.from_map_path (path)
   local data = dofile(path)
   local self = {
      tiles = tiles.from_data(data)
   }
   oop.instance(world, self)
   tform.xscale = data.tilewidth / 2
   tform.yscale = data.tileheight / 2
   tform.xoff = 0
   tform.yoff = 0
   return self
end

function world:update (input)
   input = input[1]
   if input.du>0 then tform.yoff = tform.yoff + 1 end
   if input.dd>0 then tform.yoff = tform.yoff - 1 end
   if input.dl>0 then tform.xoff = tform.xoff + 1 end
   if input.dr>0 then tform.xoff = tform.xoff - 1 end
   if input.b==1 then (require 'src/scene').pop() end
end

function world:draw ()
   lg.clear(0,0,0)
   self.tiles:draw()
   depthdraw.draw()
end

return world
