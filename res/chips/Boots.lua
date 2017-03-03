local actors = require "src/battle/actors"

return {
   act = function (actor)
      actors.add(
         {x=actor.x+0.3, y=actor.y, z=40,
          img="boots", damage=40,
          sheet={0,0,24,16,6,1}
         },
         "bullet"
      )

   end
}
