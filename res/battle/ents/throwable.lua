local stage = require "battle/stage"

return {
   class = {
      dx = 3/60,
      lifespan = 60,
      start = function (self)
         self.parent.enter_state = "throw"
      end,
      update = function (self)
         self.dz = self.dz - 1/20
         if self.time == 60 then
            self:hit_ground()
         end
      end,
   },
   variants = {
      poison = {
         img = "poisdrop",
         z=40, dz = 1,
         hit_ground = function (self)
            stage.apply_stat("poison", 600, self.x, self.y)
         end,
      }
   }
}
