local o = require "actors/actor"

o.idle = function ()
   -- Player moves based on user input
   if     input.check("a")     then o.shoot()
   elseif input.check("up")    then o.move{x=o.space.x,   y=o.space.y-1}
   elseif input.check("down")  then o.move{x=o.space.x,   y=o.space.y+1}
   elseif input.check("left")  then o.move{x=o.space.x-1, y=o.space.y}
   elseif input.check("right") then o.move{x=o.space.x+1, y=o.space.y}
   end
end

o.idle_init = function ()
   o.state = o.idle
   o.frame = o.frames[1][1]
   o.state_timer = 0
   o.idle()
end

o.move = function (space_goal)
   input.stale("pad") -- Force button repress in order to move twice
   if stage.canGo(space_goal, o.side) then
      o.state = o.cooldown
      o.state_timer = 0
      o.frame = o.frames[2][1]

      stage.free(o.space)
      stage.occupy(space_goal)
      o.space = space_goal
      o.pos = stage.pos(o.space)
   end
end

o.shoot = function ()
   input.stale("a")
   o.frame = o.frames[3][1]
   o.state = o.cooldown
   o.state_timer = 0
end

return o
