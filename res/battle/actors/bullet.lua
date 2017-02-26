local battle = require "src/battle/battle"

return {
   img = "res/battle/actors/bullet.png",
   sheet = {0,0,16,16,6,0},
   send=true, size=8/64,
   start = function (self)
      self.time = 0
      self.dx = 0.01
   end,

   update = function (self)
      self.time = self.time + 1
      self.dx = self.dx * 1.1
      self.x = self.x + self.dx
      if self.x > 10 then self.despawn = true end
   end,

   recv = function (self, with)
      battle.signal(self, with, "damage", 40)
      self.despawn = true
   end,
}
