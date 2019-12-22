local oop = require 'src/oop'
local point = require 'src/point'
local aloader = require 'src/actor_loader'

local base_actor = require 'world/base_actor'

local actors = oop.class()

function actors:init (world)
   self.actors = {}
   self.base = base_actor(world)
   self.aloader = aloader(self.base, 'world/actors/')

   for _,layer in ipairs(world.map.layers) do
      if layer.type == 'objectgroup' then
         for _,object in ipairs(layer.objects) do
            local out = {}
            -- These fields are accessible in the script file
            out.is_tile = false
            out.type = object.type
            out.shape = object.shape
            out.pos = point(object.x, object.y)
            out.properties = object.properties
            -- convert polyline to absolute position
            if object.shape == 'polyline' then
               out.line = {}
               for _,point in ipairs(object.polyline) do
                  out.line[#out.line+1] = point.x + object.x
                  out.line[#out.line+1] = point.y + object.y
               end
            end
            self:add(out)
         end
      end
   end
end

function actors:add (actor)
   if actor.type == 'player' then
      self.player = actor
   end
   if actor.type == '' then
      actor.type = nil
   end
   self.actors[#self.actors+1] = self.aloader:load(actor, actor.type)
end

function actors:update (input)
   -- check rectangle collisions
   for i,actor in ipairs(self.actors) do
      local _,_,w,h = self.player:rect()
      local player_center = self.player.pos + point(w,h)/2
      if actor.active and (player_center):within_rectangle(actor:rect()) then
         actor:collide(self.player)
      end
   end

   for i,actor in ipairs(self.actors) do
      if actor.active and actor.update then
         actor:update(input)
      end
   end
end

function actors:draw (scroll_pos, view_size)
   for _,object in ipairs(self.actors) do
      local opacity = object.visible and 1 or 0.5
      if object.active then
         love.graphics.setColor(1, 0, 0, opacity)
      else
         love.graphics.setColor(0, 0, 1, opacity)
      end
      if object.shape == 'point' then
         love.graphics.circle('line', object.pos.x, object.pos.y, 8)
      elseif object.shape == 'polyline' then
         love.graphics.line(object.line)
      end
   end
   love.graphics.setColor(1, 1, 1)
end

return actors
