local ents = require "battle/ents"
local chip = require "src/chip"

local ent = {
   group = "enemy",
   tangible = true,
   size=20/64,
   ox = 22, oy = 43,
   die = function (self)
      self.despawn = true
      for _ = 1,50 do
         ents.add(
            {x=self.x, y=self.y, z=20, color=self.color},
            "particle")
      end
   end
}

return {
   ent = ent,
   variants = {
      {
         img = "testenemy",
         max_hp = 40,
         color = {169, 53, 197},
      },
      {
         img = "testenemy2",
         max_hp = 80,
         color = {53, 57, 196},
         cooldown = 0,
         update = function (self)
            if math.abs(self.y-ents.player.y) < 1
               and self.cooldown<1
            then
               self.cooldown = 80
               chip.use(self, "Triangle")
            end
            self.cooldown = self.cooldown - 1
         end,
      },
   }
}
