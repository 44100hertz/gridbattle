return {
   img = "res/battle/actors/panel.png",
   sheet = {0,0,64,64,2,2},
   walkable = true,
   height = 14,

   start = function (self)
      self.z = -14
   end,

   -- update = function (self)
   --    self.z = -14
   -- end,

   draw = function (self, x, y)
      local frame = self.side=="left" and sheet[1] or sheet[3]
      love.graphics.draw(img, frame, x, y, 0, 1, 1, 32, 20)
   end,
}
