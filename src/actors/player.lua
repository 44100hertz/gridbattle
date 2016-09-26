local img, frames, origin, s_pos, pos, side
local hp, maxhp
local idle, idle_init
local move, move_init
local shoot, shoot_init
local checkInput
local inputTimer

player = { 
   init = function ()
      player.update = idle_init
      img = love.graphics.newImage("img/ben.png")
      frames = sheet.generate({x=50, y=60}, {x=1, y=5}, img:getDimensions())
      origin = {x=25, y=57}
      s_pos = {x=1, y=1}
      side = "left"
      pos = stage.pos(s_pos)
   end,

   draw = function ()
      love.graphics.draw(img, frame, pos.x, pos.y, 0, 1, 1, origin.x, origin.y)
   end
}

function idle_init()
   frame = frames[1][1]
   player.update = idle
   idle()
end

function idle()
   checkInput()
end

function checkInput()
   if input.check("a")     then shoot_init() end
   if input.check("up")    then move_init{x=s_pos.x,   y=s_pos.y-1} end
   if input.check("down")  then move_init{x=s_pos.x,   y=s_pos.y+1} end
   if input.check("left")  then move_init{x=s_pos.x-1, y=s_pos.y} end
   if input.check("right") then move_init{x=s_pos.x+1, y=s_pos.y} end
end

function move_init(s_goal)
   input.stale("pad")
   if stage.canGo(s_goal, side) then
      frame = frames[2][1]
      inputTimer = 10
      stage.free(s_pos)
      stage.occupy(s_goal)
      s_pos = s_goal
      pos = stage.pos(s_pos)
      player.update = move
      move()
   else
      checkInput()
   end
end

function move()
   if inputTimer > 0 then inputTimer = inputTimer - 1
   else idle_init() end
end

function shoot_init()
   input.stale("a")
   inputTimer = 10
   frame = frames[3]
   player.update = shoot
   shoot()
end

function shoot()
   if inputTimer > 0 then inputTimer = inputTimer - 1
   else idle_init() end
end
