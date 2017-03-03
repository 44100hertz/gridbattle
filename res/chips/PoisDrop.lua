local stage = require "src/battle/stage"

local ent = {
   start = function (self)
      stage.apply_stat("poison", 600, _, self.x+3, self.y)
   end
}

return {
   ent=ent,
}
