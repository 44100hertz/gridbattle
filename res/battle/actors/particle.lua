local stage = require "src/battle/stage"
local gravity = 0.1

return {
   start = function (self)
      local dr = math.random() / 16 + 1/32
      local theta = math.random() * 2 * math.pi
      self.dx = dr * math.sin(theta)
      self.dy = dr * math.cos(theta)
      self.dz = math.random() * 5
   end,

   update = function (self)
      self.dz = self.dz - gravity
   end,

   draw = function (self, x, y)
      love.graphics.setColor(169, 53, 197, 255)
      love.graphics.circle("fill", x, y, 5, 4)
      love.graphics.setColor(255, 255, 255, 255)
   end,
}
