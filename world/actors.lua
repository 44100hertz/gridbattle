local oop = require 'src/oop'
local point = require 'src/point'

local proto_actor = require 'world/proto_actor'

local actors = oop.class()

function actors:init (data)
   self.actors = {}
   self.actor_cache = {}

   for _,layer in ipairs(data.layers) do
      if layer.type == 'objectgroup' then
         for _,object in ipairs(layer.objects) do
            self.actors[#self.actors+1] = {layer.type}
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
         setmetatable(actor, {__index = proto_actor})
      else
         if not self.actor_cache[actor.type] then
            self.actor_cache[actor.type] = dofile('world/actors/' .. actor.type .. '.lua')
            setmetatable(self.actor_cache[actor.type], {__index = proto_actor})
         end
         setmetatable(actor, {__index = self.actor_cache[actor.type]})
      end
   end
end

function actors:update (input)
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
