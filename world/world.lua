local oop = require 'src/oop'
local point = require 'src/point'

local tiles = require 'world/tiles'
local actors = require 'world/actors'

local world = oop.class()

function world:init (path)
   self.scroll_pos = point(0, 0)
   self.view_size = point(352, 224)

   self.map = dofile(path)
   self.scroll_speed = 8
   self.tiles = tiles(self.map, path)
   self.tile_size = point(self.map.tilewidth, self.map.tileheight)
   self.actors = actors(self.map)
   self.border_shader = love.graphics.newShader('res/shaders/border.glsl')
   self.border_shader:send('scale', GAME.config.settings.game_scale)
   self.border_shader:send('size', {self.view_size:unpack()})
   self.border_shader:send('position', {(GAME.size/2 - self.view_size/2):unpack()})
end

function world:update (input)
   if input[1].st==1 then GAME.scene:pop() end
   self.actors:update(input)
end

function world:draw ()
   do
      -- smooth scroll follows player
      local goal = self.actors.player.pos - self.view_size/2 + self.map.tilewidth/2
      self.scroll_pos = self.scroll_pos:lerp(goal, 0.2)
      local border_size = (GAME.size - self.view_size) * 0.5
      local offset = -self.scroll_pos + border_size
      love.graphics.translate(offset:unpack())
   end
   love.graphics.clear(0,0,0)
   love.graphics.setShader(self.border_shader)
   self.tiles:draw(self.scroll_pos - self.tile_size, self.view_size + self.tile_size*2)
   self.actors:draw(self.scroll_pos - self.tile_size, self.view_size + self.tile_size*2)
   love.graphics.setShader()
end

return world
