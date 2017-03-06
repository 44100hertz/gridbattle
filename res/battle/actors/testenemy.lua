local actors = require "src/battle/actors"
local chip = require "src/chip"

local ent = {
   group = "enemy",
   tangible = true,
   size=20/64,
   ox = 22, oy = 43,
   die = function (self)
      self.despawn = true
      for _ = 1,50 do
         actors.add({x=self.x, y=self.y, z=20, color=self.color},
            "particle")
      end
   end
}

return {
   ent = ent,
   variants = {
      purple = {
         img = "testenemy",
         max_hp = 40,
         color = {169, 53, 197},
      },
      blue = {
         img = "testenemy2",
         max_hp = 80,
         color = {53, 57, 196},
         update = function (self)
            if self.time%60 == 0 then
               chip.use(self, "Triangle")
            end
         end,
      },
   }
}
