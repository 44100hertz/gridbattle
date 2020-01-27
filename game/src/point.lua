-- A general purpose 2-dimensional coordinate type.
-- initialized like a class, i.e. point(x, y), though a custom metatable is used

-- Points are often used as arguments. Library functions should generally not
-- modify input points, and use point:copy().

local point = {}

local function init (x, y)
   return setmetatable({x=x, y=y}, point.mt)
end

function point:unpack ()
   return self.x, self.y
end

function point:copy ()
   return init(self.x, self.y)
end

function point:map (fun)
   return init(fun(self.x), fun(self.y))
end

function point:floor ()
   return self:map(math.floor)
end

function point:round ()
   return (self + 0.5):floor()
end

function point:lerp (other, weight)
   return (self * (1-weight) + other * weight)
end

function point:within_rectangle (x, y, w, h)
   local x0, x1, y0, y1 = x, x+w, y, y+h
   return self.x >= x0 and self.x <= x1 and self.y >= y0 and self.y <= y1
end

-- length from 0,0
function point:length ()
   return math.sqrt(self.x * self.x + self.y * self.y)
end

function point:distance_to(other)
   return (self - other):length()
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
function point.mt.__eq (p, q)
   return p.x == q.x and p.y == q.y
end

return init
