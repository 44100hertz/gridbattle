local text = require "src/text"
local anim = require "src/anim"

local img = love.graphics.newImage("res/battle/ui.png")
local sb = love.graphics.newSpriteBatch(img, 40, "stream")
local w,h = img:getDimensions()
local bar = anim.sheet(0,16,8,8,3,1,w,h)[1]
local bar_width = 128
local bar_x = GAME.width/2 - bar_width/2

return {
   draw = function (hp, cust_frames)
      local full_amt = cust_frames / CUST_TIME * bar_width
      local bar_size = math.min(full_amt, bar_width-2)

      local red = 40
      if cust_frames >= CUST_TIME then
         red = (math.sin(love.timer.getTime()*4 % math.pi)+1) * 100
      end

      love.graphics.setColor(red, 40, 40)
      love.graphics.rectangle("fill", bar_x+1, 8, bar_size, 8)
      love.graphics.setColor(255, 255, 255)

      sb:clear()
      if hp and hp>0 then
         text.draw("visible", tostring(math.floor(hp)), 8, 8)
      end
      local x,y = bar_x, 8
      local segs = bar_width/8 - 2
      sb:add(bar[1], x, y)
      for _=1,segs do
         x = x + 8
         sb:add(bar[2], x, y)
      end
      x = x + 8
      sb:add(bar[3], x, y)
      love.graphics.draw(sb)
   end,
}
