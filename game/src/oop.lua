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
