-- Actor Loader is a way of loading the types for actors efficiently, and
-- handles inheritance.

local oop = require 'src/oop'

local aloader = oop.class()

function aloader:init (base_actor, base_path)
   self.base = base_actor
   self.path = base_path
   self.cache = {}
end

-- Load an actor or class.
-- This will chain its type tables.
function aloader:load (actor, atype)
   if atype then
      if not self.cache[atype] then
         local class = love.filesystem.load(self.path .. atype .. '.lua')()
         self.cache[atype] = setmetatable(class, {__index = self.base})
      end
      return setmetatable(actor, {__index = self.cache[atype]})
   else
      return setmetatable(class, {__index = self.base})
   end
end

return aloader
