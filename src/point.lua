-- A general purpose 2-dimensional coordinate type.
-- initialized like a class, i.e. point(x, y), though a custom metatable is used

local point = {}

local function init (x, y)
   return setmetatable({x=x, y=y}, point.mt)
end

function point:unpack ()
   return self.x, self.y
end

function point:map (fun)
   return init(fun(self.x), fun(self.y))
end

function point:floor ()
   return self:map(math.floor)
end

point.mt = {}
point.mt.__index = point
function point.mt.__unm (p)
   return init(-p.x, -p.y)
end
function point.mt.__add (p, q)
   q = type(q) == 'number' and init(q, q) or q
   return init(p.x + q.x, p.y + q.y)
end
function point.mt.__sub (p, q)
   q = type(q) == 'number' and init(q, q) or q
   return init(p.x - q.x, p.y - q.y)
end
function point.mt.__mul (p, q)
   q = type(q) == 'number' and init(q, q) or q
   return init(p.x * q.x, p.y * q.y)
end
function point.mt.__div (p, q)
   q = type(q) == 'number' and init(q, q) or q
   return init(p.x / q.x, p.y / q.y)
end

return init
