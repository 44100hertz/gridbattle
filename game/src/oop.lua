--[[
   oop: A basic class framework for lua.

   -- Declaring a class --
   local my_class = oop.class{x = y, ...} (default fields)
   Constructors are either:
      A: function my_class:init (...)
         Binds class methods to empty table {} before running.
      B: function my_class.manual_init (...)
         Must return constructed object.

   -- Instantiating a class --
   my_class(...)
]]

local oop = {}

local class_mt = {
   __call = function (class, ...)
      if class.manual_init then
         return class.manual_init(...)
      else
         local object = setmetatable({}, {__index = class})
         if object.init then
            object:init(...)
         end
         return object
      end
   end,
}
function oop.class (base)
   return setmetatable(base or {}, class_mt)
end

function oop.bind (class, func)
   return function (...)
      func(class, ...)
   end
end

function oop.bind_by_name(class, path)
   return oop.bind(class, class[path])
end

return oop
