local battle = require "src/battle/battle"
local anim = require "src/anim"

local img = love.graphics.newImage("res/battle/actors/testenemy.png")

local sheet = anim.sheet(
   0, 0, 50, 60, img:getWidth(), img:getHeight(), 1, 1)

return {
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

   draw = function (self, x, y)
      love.graphics.draw(img, sheet[1], x, y, 0, 1, 1, 22, 8)
   end,

   damage = function (self, from, amount)
      self.hp = self.hp - amount
   end,
}
