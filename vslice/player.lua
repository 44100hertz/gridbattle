local idle, move, shoot

player = {
   x=0, y=0,
   img = love.graphics.newImage("ben.png"),
   action = idle,
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
   if love.keyboard.isDown('s') then
      actionTimer = 10
      player.action = shoot
   elseif love.keyboard.isDown('a') then
      x_goal=player.x-40
   elseif love.keyboard.isDown('o') then
      y_goal=player.y+24
   elseif love.keyboard.isDown('e') then
      y_goal=player.y-24
   elseif love.keyboard.isDown('u') then
      x_goal=player.x+40
   end
end

function move()
   local x = player.x
   local y = player.y
   if((x + y) % 10 < 5) then player.frame = frames.idle
   else player.frame = frames.move
   end
   if x_goal < x then x=x-2 end
   if x_goal > x then x=x+2 end
   if y_goal < y then y=y-2 end
   if y_goal > y then y=y+2 end
   if x==x_goal and y==y_goal then
      player.action = idle
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
