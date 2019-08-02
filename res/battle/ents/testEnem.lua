local ents = require "battle/ents"
local ai = require "battle/ai"
local chip = require "battle/chip_wrangler"

local class = {
   tangible = true,
   size=20/64,
   noflip = true,
   die = function (self)
      self.despawn = true
      for _ = 1,50 do
         ents.add("particle", nil,
            {x=self.x, y=self.y, z=20, color=self.color})
      end
   end
}

return {
   class = class,
   variants = {
      {
         img = "testenemy",
         max_hp = 40,
         color = {169/255.0, 53/255.0, 197/255.0},
      },
      {
         img = "testenemy2",
         max_hp = 80,
         color = {53/255.0, 57/255.0, 196/255.0},
         cooldown = 0,
         update = function (self)
            if ai.see_line(self.x, self.y, self.side) and
               self.cooldown<1
            then
               self.cooldown = 80
               chip.use(self, "Triangle")
            end
            self.cooldown = self.cooldown - 1
         end,
      },
   }
}
