local idle, move, shoot

player = {
   x=0, y=0,
   img = love.graphics.newImage("ben.png"),
}

local actionTimer = 0
local x_goal, y_goal = 0,0
local width = player.img:getWidth()
local height = player.img:getHeight()   
local frames = {
   idle = love.graphics.newQuad(0, 0, 49, 60, width, height),
   move = love.graphics.newQuad(0, 60, 49, 60, width, height),
   shoot = love.graphics.newQuad(0, 120, 49, 60, width, height)
}
player.frame = frames.idle

function idle()
   player.frame = frames.idle
   if input.check("a",10) then
      actionTimer = 20
      player.action = shoot
   elseif input.check("left",10) then
      x_goal=player.x-40
      input.stale()
      move()
   elseif input.check("down",10) then
      y_goal=player.y+24
      input.stale()
      move()
   elseif input.check("up",10) then
      y_goal=player.y-24
      input.stale()
      move()
   elseif input.check("right",10) then
      x_goal=player.x+40
      input.stale()
      move()
   end
end

function move()
   local x = player.x
   local y = player.y
   if((x + y*2) % 15 < 6) then player.frame = frames.idle
   else player.frame = frames.move
   end
   if x_goal < x then x=x-5/2
   elseif x_goal > x then x=x+5/2
   elseif y_goal < y then y=y-3/2
   elseif y_goal > y then y=y+3/2
   else
      player.action = idle
      idle()
   end
   player.x = x
   player.y = y
end

function shoot()
   player.frame = frames.shoot
   actionTimer=actionTimer-1
   if actionTimer==0 then player.action = idle end
end

function player.update()
   player.action = player.action or idle
   if not (player.x==x_goal and player.y==y_goal) then
      player.action = move
   end
   player.action()
end
