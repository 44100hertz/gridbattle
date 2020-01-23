--[[ Actor loader initializes actors using a "sandwich method"

On the bottom, the 'base actor' carries utility methods inherited by every
class. In the middle is the class, which overrides some base actor methods
(usually callbacks) and properties, and calls other methods. On the top is the
actor instance, and its state is mostly data. The metatable chain is as follows:

   Actor instance -> Actor's class -> Base Actor

Actors can also have components. Components are added any time using
actor:attach(<component name>, <arguments...>). This will add a component inside
actor[<component name>]. For example, self:attach('timer', 0) could add a
self.timer field loaded from <base path>/components/timer.lua, with its initial
time set to 0. self.timer:seconds() would give seconds elapsed.
--]]

local oop = require 'src/oop'

local actor_loader = oop.class()

-- @base_actor contains the "bottom" methods inherited by every class
-- @base_path is where the actors/ and components/ folders are located
function actor_loader:init (base_actor, base_path)
   self.base_actor = base_actor

   self.actors_path = base_path .. 'actors/'
   self.actor_cache = {}

   self.components_path = base_path .. 'components/'
   self.components_cache = {}

   function self.base_actor.attach (base, name, ...)
      if not self.components_cache[name] then
         local path = self.components_path .. name .. '.lua'
         self.components_cache[name] = love.filesystem.load(path)()
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
   return actor
end

return actor_loader
