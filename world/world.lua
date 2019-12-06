local tiles = require 'world/tiles'
local oop = require 'src/oop'
local point = require 'src/point'

local world = oop.class()

function world:init (path)
   local data = dofile(path)
   self.tiles = tiles(data, path)
   self.pos = point(176, 824)
   self.scroll_speed = 8
end

function world:update (input)
   input = input[1]
   if input.du>0 then self.pos.y = self.pos.y - self.scroll_speed end
   if input.dd>0 then self.pos.y = self.pos.y + self.scroll_speed end
   if input.dl>0 then self.pos.x = self.pos.x - self.scroll_speed end
   if input.dr>0 then self.pos.x = self.pos.x + self.scroll_speed end
   if input.b==1 then GAME.scene:pop() end
end

function world:draw ()
   love.graphics.clear(0,0,0)
   self.tiles:draw(self.pos)
end

return world
