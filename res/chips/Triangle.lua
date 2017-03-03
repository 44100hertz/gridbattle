local actors = require "src/battle/actors"

return {
   act = function (actor)
      actors.add(
         {x=actor.x+0.3, y=actor.y, z=40,
          img="bullet", damage=40,
         },
         "bullet"
      )
   end
}
