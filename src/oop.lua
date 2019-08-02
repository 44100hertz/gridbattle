local oop = {}

function oop.instance (class, object)
   return setmetatable(object or {}, {__index = class})
end

return oop
