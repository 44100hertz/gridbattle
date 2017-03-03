local actors = require "src/battle/actors"

return {
   img="wheel_crate",
   sheet={0,0,45,60,1,1,45,60},
   tangible=true,
   ox=17, oy=35,
   start = function (self)
      self.x = self.x + 2
   end,
}
