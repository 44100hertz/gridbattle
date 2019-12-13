-- A generalized actor loader for the "class sandwich" approach I'm beginning to
-- favor. Every actor has 2 layers of inheritance:

--     1. The "proto actor": Every actor inherits these properties, which
--     consist of a set of functions that would be useful to all actors.

--     2. The "type": by having a 'type' field, the actor can inherit a set of
--     functions specific to a class of actors.

-- And on top of this, a set of custom properties (and possibly functions?) can
-- be applied to the actor. This nicely separates things into engine-level,
-- script-level, and data-level.

local oop = require 'src/oop'

local aloader = oop.class()

function aloader:init (proto_actor, base_path)
   self.proto = proto_actor
   self.path = base_path
   self.cache = {}
end

function aloader:add (actor)
   if actor.type == '' then
      setmetatable(actor, {__index = self.proto})
   else
      if not self.cache[actor.type] then
         self.cache[actor.type] = dofile(self.path .. actor.type .. '.lua')
         setmetatable(self.cache[actor.type], {__index = proto_actor})
      end
      setmetatable(actor, {__index = self.cache[actor.type]})
   end
   return actor
end

return aloader
