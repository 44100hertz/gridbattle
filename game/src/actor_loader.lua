-- Actor loader initializes actors using a "sandwich method"
--  - On the bottom, the base actor, which carries utility methods
--  - In the middle, there is the actor's class, general behaviors.
--  - On the top, the actor instance, its current state

-- Above the actor instance lies components. Components are added any time using
-- actor:attach(<component name>, <arguments...>). This will add a component
-- inside actor[<component name>]. For example, self:attach('timer', 0) may add
-- a self.timer field loaded from <base path>/components/timer.lua, where
-- self.timer:seconds() is a method.

local oop = require 'src/oop'

local actor_loader = oop.class()

-- @base_actor contains the "bottom" methods, things that make the actor function.
-- @base_path is where the actors/ and components/ folders need to be located
function actor_loader:init (base_actor, base_path)
   self.base_actor = base_actor

   self.actors_path = base_path .. 'actors/'
   self.actor_cache = {}

   self.components_path = base_path .. 'components/'
   self.components_cache = {}

   function self.base_actor.attach (base, name, ...)
      if not self.components_cache[name] then
         self.components_cache[name] = dofile('battle/components/' .. name .. '.lua')
      end
      local class = self.components_cache[name]
      local component = setmetatable({}, {__index = class})
      base[name] = component
      base.components[#base.components+1] = component
      component:init(base, ...)
   end
end

-- set up and initialize an actor instance
function actor_loader:load (actor, class_name)
   -- Initialize class for actor
   if not self.actor_cache[class_name] then
      local class = love.filesystem.load(self.actors_path .. class_name .. '.lua')()
      setmetatable(class, {__index = self.base_actor})
      self.actor_cache[class_name] = class
   end
   setmetatable(actor, {__index = self.actor_cache[class_name]})

   actor.components = {}
   actor:init()
   return actor
end

return actor_loader
