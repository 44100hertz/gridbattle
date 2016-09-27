local idle, move, shoot
local state_timer = 0

local state
local speed = 1
local img = love.graphics.newImage("img/ben.png")
local frames = sheet.generate({x=50, y=60}, {x=1, y=5}, img:getDimensions())
local origin = {x=25, y=57}
local space = {x=1, y=1}
local side = "left"
local pos = stage.pos(space)
stage.occupy(space)

function idle()
   if state ~= idle then
      state = idle
      frame = frames[1][1]
      state_timer = 0
   end
   if     input.check("a")     then shoot()
   elseif input.check("up")    then move{x=space.x,   y=space.y-1}
   elseif input.check("down")  then move{x=space.x,   y=space.y+1}
   elseif input.check("left")  then move{x=space.x-1, y=space.y}
   elseif input.check("right") then move{x=space.x+1, y=space.y}
   end
end

function move(space_goal)
   if state ~= move then
      input.stale("pad")
      if stage.canGo(space_goal, side) then
	 frame = frames[2][1]
	 stage.free(space)
	 stage.occupy(space_goal)
	 space = space_goal
	 pos = stage.pos(space)
	 state = move
	 state_timer = 0
      end
   end
   if state_timer > 10 then
      return idle()
   end
end

function shoot()
   if state ~= shoot then
      input.stale("a")
      frame = frames[3]
      state = shoot
   end
   if state_timer > 10 then
      return idle()
   end   
end

player = {
   update = function ()
      if state then state() else idle() end
      state_timer = state_timer + speed
   end,

   draw = function ()
      love.graphics.draw(img, frame, pos.x, pos.y, 0, 1, 1, origin.x, origin.y)
   end
}

return player
