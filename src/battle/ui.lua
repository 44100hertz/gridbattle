local img = love.graphics.newImage("res/battle/ui.png")
local sb = love.graphics.newSpriteBatch(img, 40, "stream")
local anim = require "src/anim"
local w,h = img:getDimensions()
local sheet = {
   numbers = anim.sheet(0,0,8,11,10,1,w,h)[1],
   hp = anim.sheet(0,16,8,4,1,1,w,h)[1][1],
   time = anim.sheet(0,16,16,4,1,1,w,h)[1][1],
   bar = anim.sheet(0,24,8,8,3,1,w,h)[1],
}
local bar_width = 128
local bar_x = GAME.width/2 - bar_width/2

return {
   draw = function (hp, cust_frames)
      local full_amt = cust_frames / CUST_TIME * bar_width
      local bar_size = math.min(full_amt, bar_width-2)

      love.graphics.setColor(40, 40, 40)
      love.graphics.rectangle("fill", bar_x+1, 8, bar_size, 8)
      love.graphics.setColor(255, 255, 255)

      sb:clear()
      local x,y = 8,8
      for char in tostring(hp):gmatch(".") do
         sb:add(sheet.numbers[char:byte() - ("0"):byte() + 1], x, y)
         x = x + 8
      end
      local x,y = bar_x, 8
      local segs = bar_width/8 - 2
      sb:add(sheet.bar[1], x, y)
      for _=1,segs do
         x = x + 8
         sb:add(sheet.bar[2], x, y)
      end
      x = x + 8
      sb:add(sheet.bar[3], x, y)
      love.graphics.draw(sb)
   end,
}
