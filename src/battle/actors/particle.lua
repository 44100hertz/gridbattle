local battle = require "battle/battle"

local gravity = 0.1
return {
   start = function (self, img)
      local dr = math.random() / 16 + 1/32
      local theta = math.random() * 2 * math.pi
      self.dx = dr * math.sin(theta)
      self.dy = dr * math.cos(theta)
      self.dz = math.random() * 10 - 5
      self.time = 0
   end,

   update = function (self)
      self.dz = self.dz - gravity
      self.x = self.x + self.dx
      self.y = self.y + self.dy
      self.z = self.z + self.dz

      local floor = battle.getpanel(self.x, self.y)
      self.floorz = (floor and floor.z) and floor.z+floor.class.height or nil
      if self.floorz and self.z+self.dz < self.floorz then self.dz = -self.dz end

      if self.time == 256 then
	 self.despawn = true
      end

      self.time = self.time + 1
   end,

   draw = function (self, x, y)
      love.graphics.setColor(169, 53, 197, 255)
      love.graphics.circle("fill", x, y, 5)
      love.graphics.setColor(255, 255, 255, 255)
   end,
}
