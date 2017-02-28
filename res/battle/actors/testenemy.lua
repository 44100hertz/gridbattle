local actors = require "src/battle/actors"
local stage = require "src/battle/stage"

return {
   img = "res/battle/actors/testenemy.png",
   sheet = {0,0,50,60,1,1},
   group = "enemy",
   tangible = true,
   size=20/64,
   height = 40,
   hp = 80,
   ox = 22, oy = 3,

   start = function (self)
      stage.occupy(self, self.x, self.y, "right")
   end,

   update = function (self)
      if self.hp <= 0 then
         self.despawn = true
         for _ = 1,100 do
            actors.add(
               {x=self.x, y=self.y, z=self.z-20},
               require "res/battle/actors/particle"
            )
         end
      end
   end,
}
