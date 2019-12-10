local oop = require 'src/oop'
local point = require 'src/point'

local tiles = require 'world/tiles'
local objects = require 'world/objects'

local world = oop.class()

function world:init (path)
   self.scroll_pos = point(0, 0)
   self.view_size = point(336, 208)

   self.map = dofile(path)
   self.scroll_speed = 8
   self.tiles = tiles(self.map, path)
   self.objects = objects(self.map)
end

function world:update (input)
   input = input[1]
   if input.st==1 then GAME.scene:pop() end
   self.objects:update(input)
end

function world:draw ()
   do
      -- smooth scroll follows player
      local goal = self.objects.player.pos - self.view_size/2 + self.map.tilewidth/2
      self.scroll_pos = self.scroll_pos*0.9 + goal*0.1
      local border_size = (GAME.size - self.view_size) * 0.5
      local offset = -self.scroll_pos + border_size
      love.graphics.translate(offset:unpack())
   end
   love.graphics.clear(0,0,0)
   self.tiles:draw(self.scroll_pos, self.view_size)
   self.objects:draw(self.scroll_pos, self.view_size)
end

return world
