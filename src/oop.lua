local oop = {}

function oop.instance (class, object)
   return setmetatable(object or {}, {__index = class})
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
