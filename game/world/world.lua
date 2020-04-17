local oop = require 'src/oop'

local tiles = require 'world/tiles'
local actors = require 'world/actors'

local world = oop.class()

   --- work notes (I have to go to work!) the current system is based on an
   --- older idea of how maps should work. I wanted to have the map inside tiled
   --- be a relatively visually accurate representation of the map, so it
   --- follows that I transformed Tiled concepts into map concepts. Now I am
   --- feeling that it is better to scrap that notion, and focus on creating
   --- collision maps in tiled that will go through a process later in
   --- development, wherein they are first auto-transformed into visual maps,
   --- and then subject to hand-editing for prettification. This way, I can get
   --- gameplay nuts and bolts into practice ASAP. Actors will be reserved for a
   --- single object layer that should be present on every map. Yes, this means
   --- making a lot of objects, but it really isn't that complex. To speed the
   --- process, I will also create live map reloading (with error handling!) so
   --- that I can quickly see the results of my work. It was a mistake to
   --- attempt to use tiled as a WYSIWYG editor, and it is possible that in the
   --- future I will either create or adapt an editor for the specific purposes
   --- achieved here. Right now, my goal is rapid prototyping over everything.
   ---
   --- So, here's what I can expect to do:
   ---  - Scrap the existing map concepts when it no longer fits this new minimal concept
   ---  - Create a pre-loading layer, either at load-time or build-time
   ---  - Implement live map reloading with error handling.
   ---  - Map debugging features for viewing and testing maps.
function world:init (path)
   self.scroll_pos = point(0, 0)
   self.view_size = point(21 * 16, 13 * 16)

   self.map = love.filesystem.load(path .. 'map.lua')()
   self.scroll_speed = 8
   self.tiles = tiles(self.map, path)
   self.tile_size = point(self.map.tilewidth, self.map.tileheight)
   self.actors = actors(self)

--   self.tiles:add_tile_actors(self.actors)

   -- REVIEW: love2d has clipping functions I can use instead of this shader.
   -- However, can this shader have desirable results not achievable there?
   self.border_shader = love.graphics.newShader('shaders/border.glsl')
   self.border_shader:send('scale', GAME.config.settings.game_scale)
   self.border_shader:send('size', {self.view_size:unpack()})
   self.border_shader:send('position', {(GAME.size/2 - self.view_size/2):unpack()})
end

function world:update ()
   if GAME.input:hit'start' then
      GAME.scene:pop()
   end
   self.actors:update()
end

function world:draw ()
   do
      -- smooth scroll follows player
      local goal = self.actors.player.pos - self.view_size/2
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
