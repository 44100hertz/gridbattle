local actors = require "src/battle/actors"

local boot = {
   img="boots",
   sheet={0,0,24,16,2,1},
   damage=40,
   collide_die=true,
   lifespan=120,
   size=0.1,
   dx=0.1,
}

return {
   act = function (actor)
      actors.add(
         {x=actor.x+0.3, y=actor.y, z=40, frame=1},
         boot
      )
   end
}
