local oop = require 'src/oop'
local image = require 'src/image'
local aloader = require 'src/actor_loader'

local base_actor = require 'world/base_actor'

local world = oop.class()

world.directions = {
   l = {offset = point(-1,0), opposite = 'r'},
   r = {offset = point(1,0), opposite = 'l'},
   u = {offset = point(0,-1), opposite = 'd'},
   d = {offset = point(0,1), opposite = 'u'},
}

world.geometries = {
   flat = {l = 'flat', r = 'flat', u = 'flat', d = 'flat'},
   vertical = {l = 'vertical', r = 'vertical', u = 'flat', d = 'flat'},
   -- TODO: implement slopes
   slope_l = {l = 'flat', r = 'flat', u = 'slope_l', d = 'slope_l'},
   slope_r = {l = 'flat', r = 'flat', u = 'slope_r', d = 'slope_r'},
}

function world:add_actor (actor)
   if actor.type == 'spawn' then
      self.spawns[actor.name] = actor
      if actor.properties.default_spawn then
         self.default_spawn = actor
      end
   elseif actor.type == '' then
      actor.type = 'dummy'
   end
   self.actors[#self.actors+1] = self.aloader:load(actor, actor.type)
   actor:init(self)
   return actor
end

-- Get a tile using a worldmap position
function world:tile_at (pos)
   return self:get_tile((pos / self.tile_size):floor())
end

-- Get a tile using x and y index
function world:get_tile (pos)
   local index = pos.x + pos.y * self.map.width + 1
   local t = self.map.layers[1].data[index]
   if t == 0 then t = nil end
   return t
end

   -- Return true if can walk in direction (l, r, u, or d) from pos
function world:can_walk(pos, direction)
   local dd = self.directions[direction]
   local dest = pos + dd.offset * self.tile_size
   if not self:tile_at(dest) then
      return false
   end
   local function g (p, dir)
      local props = self.tile_properties[self:tile_at(p) or 0]
      local geom = props and self.geometries[props.geom]
      return geom and geom[dir]
   end
   return self.tile_properties[self:tile_at(dest)].walk and
      g(pos, direction) == g(dest, dd.opposite)
end

function world:init (map_name, spawn_point)
   self.view_size = point(21 * 16, 13 * 16)

   self.base = base_actor()
   self.aloader = aloader(self.base, 'world/')
   self:set_map(map_name, spawn_point)

   -- REVIEW: love2d has clipping functions I can use instead of this shader.
   -- However, can this shader have desirable results not achievable there?
   self.border_shader = love.graphics.newShader('shaders/border.glsl')
   self.border_shader:send('scale', GAME.config.settings.game_scale)
   self.border_shader:send('size', {self.view_size:unpack()})
   self.border_shader:send('position', {(GAME.size/2 - self.view_size/2):unpack()})
end

function world:set_map (name, spawn_point, spawn_offset)
   self.map_name = name

   self.actors = {}
   self.spawns = {}

   local path = 'world/maps/' .. name .. '/'
   self.map = love.filesystem.load(path .. 'map.lua')()
   self.tileset = self.map.tilesets[1]
   self.scroll_speed = 8

   self.tile_size = point(self.map.tilewidth, self.map.tileheight)
   local tileset_image_size = point(self.tileset.imagewidth, self.tileset.imageheight)
   -- HACK: for now, all maps will use the same debug graphics
   self.tileset.texture = love.graphics.newImage('world/maps/land-layout.png')
--   local imgpath = path .. self.tileset.image
--   self.tileset.texture = love.graphics.newImage(imgpath)
   self.tileset.sheet = image.make_quads(
      point(0,0), self.tile_size,
      (tileset_image_size / self.tile_size):floor(), tileset_image_size)

   -- Create a more convenient lookup table for tile properties.
   self.tile_properties = {}
   for i,tile in ipairs(self.tileset.tiles) do
      self.tile_properties[i] = tile.properties
   end

   -- Load actors from map
   for _,object in ipairs(self.map.layers[2].objects) do
      local out = {}
      -- These fields are accessible in the script file
      out.name = object.name
      out.type = object.type
      out.shape = object.shape
      out.pos = point(object.x, object.y)
      out.size = point(object.width, object.height)
      out.properties = {}
      for k,v in pairs(object.properties) do
         out.properties[k] = v
      end
      -- convert polyline to absolute position
      if object.shape == 'polyline' then
         out.line = {}
         for _,p in ipairs(object.polyline) do
            out.line[#out.line+1] = p.x + object.x
            out.line[#out.line+1] = p.y + object.y
         end
      end
      self:add_actor(out)
   end

   self.tile_size = point(self.map.tilewidth, self.map.tileheight)

   if not spawn_point then
      if self.default_spawn then
         self.spawn = self.default_spawn
      else
         print('Warning: no spawn point specified for map', name)
         local k,v = next(self.spawns); self.spawn = v -- just set it to something
      end
   else
      self.spawn = self.spawns[spawn_point]
   end
   self.player = self:add_actor{
      type = 'player',
      shape = 'point',
      pos = self.spawn.pos + (spawn_offset or point(0,0)),
      size = point(0,0),
   }
   self.scroll_pos = self.player.pos - self.view_size/2
end

function world:update ()
   if GAME.input:hit'start' then
      GAME.scene:pop()
   end
   -- check rectangle collisions
   for _,actor in ipairs(self.actors) do
      local pos = self.player.pos + self.tile_size/2
      if actor.active and pos:within_rectangle(actor:rect()) then
         actor:collide(self, self.player)
      end
   end

   for _,actor in ipairs(self.actors) do
      if actor.active and actor.update then
         actor:update(self)
      end
   end
end

function world:draw ()
   do
      -- smooth scroll follows player
      local goal = self.player.pos - self.view_size/2
      self.scroll_pos = self.scroll_pos:lerp(goal, 0.2)
      local border_size = (GAME.size - self.view_size) * 0.5
      local offset = -self.scroll_pos + border_size
      love.graphics.translate(offset:unpack())
   end
   love.graphics.clear(0,0,0)
   love.graphics.setShader(self.border_shader)
   self:draw_tiles(self.scroll_pos - self.tile_size, self.view_size + self.tile_size*2)
   self:draw_actors(self.scroll_pos - self.tile_size, self.view_size + self.tile_size*2)
   love.graphics.setShader()
end

function world:draw_tiles (scroll_pos, view_size)
   -- iteration boundaries
   local lower = (scroll_pos / self.tile_size):floor()+1
   local count = (view_size / self.tile_size):floor()
   local upper = lower + count

   for _,layer in ipairs(self.map.layers) do
      if layer.type == 'tilelayer' then
         for y = lower.y, upper.y do
            for x = lower.x, upper.x do
               local tile = self:get_tile(point(x,y))
               if tile then
                  love.graphics.draw(self.tileset.texture,
                                     self.tileset.sheet[tile],
                                     x * self.map.tilewidth,
                                     y * self.map.tileheight)
               end
            end
         end
      end
   end
end

function world:draw_actors ()
   -- Draw hitboxes for debug
   for _,actor in ipairs(self.actors) do
      local opacity = actor.visible and 1 or 0.5
      if actor.active then
         love.graphics.setColor(1, 0, 0, opacity)
      else
         love.graphics.setColor(0, 0, 1, opacity)
      end
      if actor.shape == 'point' then
         local size = 8
         if actor.type == 'spawn' then
            size = 2
         end
         love.graphics.circle('line', actor.pos.x+8, actor.pos.y+8, size)
      elseif actor.shape == 'rectangle' then
         love.graphics.rectangle('line', actor.pos.x, actor.pos.y, actor.size:unpack())
      elseif actor.shape == 'polyline' then
         love.graphics.line(actor.line)
      end
   end
   love.graphics.setColor(1, 1, 1)
end

return world
