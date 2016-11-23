local battle = require "battle/battle"
local gravity = 0.1

return {
   start = function (self, img)
      local dr = math.random() / 16 + 1/32
      local theta = math.random() * 2 * math.pi
      self.dx = dr * math.sin(theta)
      self.dy = dr * math.cos(theta)
      self.dz = math.random() * 5
   end,

   update = function (self)
      self.dz = self.dz - gravity
      self.x = self.x + self.dx
      self.y = self.y + self.dy
      self.z = self.z + self.dz

      local floor = battle.getpanel(self.x, self.y)
      local floorz = (floor and floor.z) and floor.z+floor.class.height
      if floorz and self.z+self.dz < floorz then self.dz = -self.dz end
   end,

   draw = function (self, x, y)
      if x < 0 or x > 400 or y > 240 then
         self.despawn = true
      end
      love.graphics.setColor(169, 53, 197, 255)
      love.graphics.circle("fill", x, y, 5, 4)
      love.graphics.setColor(255, 255, 255, 255)
   end,
}
