local oop = require 'src/oop'
local point = require 'src/point'
local aloader = require 'src/actor_loader'

local proto_actor = require 'world/proto_actor'

local actors = oop.class()

function actors:init (data)
   self.actors = {}
   self.aloader = aloader(proto_actor, 'world/actors/')

   for _,layer in ipairs(data.layers) do
      if layer.type == 'objectgroup' then
         for _,object in ipairs(layer.objects) do
            self.actors[#self.actors+1] = {}
            local out = self.actors[#self.actors]
            -- These fields are accessible in the script file
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
         end
      end
   end

   for _,actor in ipairs(self.actors) do
      if actor.type == 'player' then
         self.player = actor
      end
      if actor.type == '' then
         actor.type = nil
      end
      self.aloader:load(actor, actor.type)
   end
end

function actors:update (input)
   -- check rectangle collisions
   for i,actor in ipairs(self.actors) do
      if (self.player.pos+8):within_rectangle(actor:bounds()) then
         actor:collide(self.player)
      end
   end

   for i,actor in ipairs(self.actors) do
      actor:update(input)
   end
end

function actors:draw (scroll_pos, view_size)
   for _,object in ipairs(self.actors) do
      if object.shape == 'point' then
         love.graphics.setColor(1, 0, 0)
         love.graphics.circle('line', object.pos.x, object.pos.y, 8)
      elseif object.shape == 'polyline' then
         love.graphics.setColor(0, 0, 1)
         love.graphics.line(object.line)
      end
   end
   love.graphics.setColor(1, 1, 1)
end

return actors
