local oop = require 'src/oop'
local aloader = require 'src/actor_loader'

local base_actor = require 'world/base_actor'

local actors = oop.class()

function actors:init (world)
   self.actors = {}
   self.base = base_actor(world)
   self.aloader = aloader(self.base, 'world/')

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
               for _,p in ipairs(object.polyline) do
                  out.line[#out.line+1] = p.x + object.x
                  out.line[#out.line+1] = p.y + object.y
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
      actor.type = 'dummy'
   end
   self.actors[#self.actors+1] = self.aloader:load(actor, actor.type)
end

function actors:update (input)
   -- check rectangle collisions
   for _,actor in ipairs(self.actors) do
      local _,_,w,h = self.player:rect()
      local player_center = self.player.pos + point(w,h)/2
      if actor.active and (player_center):within_rectangle(actor:rect()) then
         actor:collide(self.player)
      end
   end

   for _,actor in ipairs(self.actors) do
      if actor.active and actor.update then
         actor:update(input)
      end
   end
end

function actors:draw ()
   -- Draw hitboxes for debug
   for _,object in ipairs(self.actors) do
      local opacity = object.visible and 1 or 0.5
      if object.active then
         love.graphics.setColor(1, 0, 0, opacity)
      else
         love.graphics.setColor(0, 0, 1, opacity)
      end
      if object.shape == 'point' then
         love.graphics.rectangle('line', object:rect())
      elseif object.shape == 'polyline' then
         love.graphics.line(object.line)
      end
   end
   love.graphics.setColor(1, 1, 1)
end

return actors
