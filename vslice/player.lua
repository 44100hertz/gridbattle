assert "sheet"
assert "stage"

local img, frames, origin, stagePos, pos
local HP
local idle, idle_init
local move, move_init
local shoot, shoot_init
local checkInput
local inputTimer

player = { 
   init = function ()
      player.update = idle_init
      img = love.graphics.newImage("ben.png")
      frames = sheet.generate(50, 60, 1, 5, img:getDimensions())
      origin_x, origin_y = 25, 57
      stage_x, stage_y = 1, 1
      posx, posy = stage.position(stage_x, stage_y)
   end,

   draw = function ()
      love.graphics.draw(img, frame, posx, posy, 0, 1, 1, origin_x, origin_y)
   end
}

function idle_init()
   frame = frames[1]
   player.update = idle
   idle()
end

function idle()
   checkInput()
end

function checkInput()
   if input.check("a") then shoot_init() end
   if input.check("up") then move_init(stage_x, stage_y-1) end
   if input.check("down") then move_init(stage_x, stage_y+1) end
   if input.check("left") then move_init(stage_x-1, stage_y) end
   if input.check("right") then move_init(stage_x+1, stage_y) end
end

function move_init(goal_x, goal_y)
   input.stale("pad")
   if stage.canGo(goal_x, goal_y, 0) then
      inputTimer = 10
      stage.free(stage_x, stage_y)
      stage.occupy(goal_x, goal_y)
      stage_x, stage_y = goal_x, goal_y
      posx, posy = stage.position(stage_x, stage_y)
      frame = frames[2]
      player.update = move
      move()
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
