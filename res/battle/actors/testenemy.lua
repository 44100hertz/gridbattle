local actors = require "src/battle/actors"

return {
   img = "testenemy",
   sheet = {0,0,50,60,1,1},
   group = "enemy",
   tangible = true,
   size=20/64,
   max_hp = 80,
   ox = 22, oy = 43,

   update = function (self)
      if self.hp <= 0 then
         self.despawn = true
         for _ = 1,100 do
            actors.add(
               {x=self.x, y=self.y, z=20}, "particle"
            )
         end
      end
   end,
}
