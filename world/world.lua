local tiles = require 'world/tiles'
local oop = require 'src/oop'

local world = oop.class()

function world:init (path)
   local data = dofile(path)
   self.tiles = tiles(data, path)
   self.x = 176
   self.y = 824
   self.scroll_speed = 8
end

function world:update (input)
   input = input[1]
   if input.du>0 then self.y = self.y - self.scroll_speed end
   if input.dd>0 then self.y = self.y + self.scroll_speed end
   if input.dl>0 then self.x = self.x - self.scroll_speed end
   if input.dr>0 then self.x = self.x + self.scroll_speed end
   if input.b==1 then GAME.scene:pop() end
end

function world:draw ()
   love.graphics.clear(0,0,0)
   self.tiles:draw(self.x, self.y)
end

return world
