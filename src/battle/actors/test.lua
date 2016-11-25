local battle = require "src/battle/battle"
local anim = require "src/anim"

local img = love.graphics.newImage("img/battle/testenemy.png")
local iw, ih = img:getDimensions()

local sheet = anim.sheet(0, 0, 50, 60, iw, ih, 1, 1)
local particle = require "src/battle/actors/particle"

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
               {class=particle, x=self.x, y=self.y, z=self.z-20}
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
