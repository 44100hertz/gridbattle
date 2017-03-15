local ents = require "battle/ents"

local bootspawner = {
   lifetime=30,
   damage=40,
   start = function (self)
      self.parent.enter_state = "shoot"
   end,
   update = function (self)
      local makeboot = function (frame)
         ents.add(
            "bullet", "boot",
            {x=self.x, y=self.y, z=40,
             group=self.group, side=self.side, damage=self.damage,
             parent=self.parent,
            })
      end
      if self.time==10 then
         makeboot(1)
      elseif self.time==30 then
         makeboot(2)
      end
   end
}

return {class=class}
