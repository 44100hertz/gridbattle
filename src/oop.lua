local oop = {}

function oop.instance (class, object)
   return setmetatable(object or {}, {__index = class})
end

local oop_metatable = {
   __call = function (class, ...)
      if class.manual_init then
         return class.manual_init(...)
      else
         local class = setmetatable(initial_table or {}, {__index = class})
         if class.init then
            class:init(...)
         end
         return class
      end
   end,
}
function oop.class (base)
   return setmetatable(base or {}, oop_metatable)
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
