local ents = require "battle/ents"

return {
   class = {
      start = function (self)
         self.parent.enter_state = "shoot"
         self.lifespan = self.delay + self.num * self.period - 1
      end,
      update = function (self)
         if self.time >= self.delay and
            (self.time-self.delay) % self.period == 0
         then
            self:spawn()
         end
      end,
   },
   variants = {
      boots = {
         count = 0,
         num = 2, delay = 10, period = 30,
         damage = 40,
         spawn = function (self)
            ents.add(
               "bullet", "boot",
               {x=self.x, y=self.y, z=40, row=0, frame=self.count,
                side=self.side, damage=self.damage, parent=self.parent,
            })
            self.count = self.count + 1
         end,
      },
   },
}
