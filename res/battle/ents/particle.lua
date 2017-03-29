local rdr = _G.RDR
local gravity = 0.1

local class = {
   start = function (self)
      local dr = math.random() / 16 + 1/32
      local theta = math.random() * 2 * math.pi
      self.dx = dr * math.sin(theta)
      self.dy = dr * math.cos(theta)
      self.dz = math.random() * 5
   end,

   update = function (self)
      self.dz = self.dz - gravity
      if self.z < -200 then self.despawn = true end
   end,

   draw = function (self, x, y)
      rdr:setDrawColor(self.color)
      rdr:fillRect{x=x, y=y, w=4, h=4}
   end,
}

return {class=class}
