local battle = require "src/battle/battle"

return {
   img = "res/battle/actors/testenemy.png",
   sheet = {0,0,50,60,1,1},
   group = "enemy",
   send = true, size=20/64,
   height = 40,

   start = function (self)
      self.stand = true
      battle.occupy(self, self.x, self.y, "right")
      self.hp = 40
   end,

   update = function (self)
      if self.hp <= 0 then
         self.despawn = true
         for _ = 1,100 do
            battle.addactor(
               {x=self.x, y=self.y, z=self.z-20},
               require "res/battle/actors/particle"
            )
         end
      end
   end,
}
