local stage = require "battle/stage"

local class = {
   img = "poisdrop",
   lifespan = 60,
   dx = 3/60,
   z=40, dz = 1,
   start = function (self)
      self.parent.enter_state = "throw"
   end,
   update = function (self)
      self.dz = self.dz - 1/20
      if self.time == 60 then
         stage.apply_stat("poison", 600, self.x, self.y)
      end
   end,
}

return {
   class=class
}
