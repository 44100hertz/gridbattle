local oop = {}

function oop.instance (class, object)
   return setmetatable(object or {}, {__index = class})
end

local oop_metatable = {
   __call = function (class, ...)
      local initial_table = class.initial_table and class.initial_table(...)
      local class = setmetatable(initial_table or {}, {__index = class})
      if class.init then
         class:init(...)
      end
      return class
   end,
}
function oop.class ()
   return setmetatable({}, oop_metatable)
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
