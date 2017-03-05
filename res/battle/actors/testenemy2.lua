local actors = require "src/battle/actors"

return {
   img = "testenemy",
   group = "enemy",
   tangible = true,
   size=20/64,
   max_hp = 80,
   ox = 22, oy = 43,

   die = function (self)
      self.despawn = true
      for _ = 1,50 do
         actors.add({x=self.x, y=self.y, z=20}, "particle")
      end
   end,
}
