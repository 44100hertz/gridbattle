return {
   img = "res/battle/actors/panel.png",
   sheet = {0,0,64,64,2,2},
   walkable = true,
   height = 14,

   start = function (self)
      self.z = -14
      self.frame = self.side == "left" and 1 or 3
   end,

   -- update = function (self)
   --    self.z = -14
   -- end,
}
