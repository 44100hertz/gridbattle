local text = require "src/text"
local anim = require "src/anim"

local img = love.graphics.newImage("res/battle/ui.png")
local sb = love.graphics.newSpriteBatch(img, 40, "stream")
local bar, bar_width, bar_x
local w,h = img:getDimensions()
local bar = anim.sheet(0,0,8,8,3,1,w,h)[1]
local bar_width = 128

return {
   draw = function (hp, cust_frames, names)
      local full_amt = cust_frames / CUST_TIME * bar_width
      local bar_size = math.min(full_amt, bar_width-2)

      local red = 40
      if cust_frames >= CUST_TIME then
         red = (math.sin(love.timer.getTime()*4 % math.pi)+1) * 100
      end

      sb:clear()
      -- HP
      if hp and hp>0 then
         text.draw("visible", tostring(math.floor(hp)), 4, 4)
      end

      -- Enemy names
      local y=4
      for _,v in ipairs(names) do
         local w,h = text.get_size("shadow", v)
         local x = GAME.width - w
         text.draw("shadow", v, x, y)
         y = y + h
      end

      -- Status bar
      local bar_x = GAME.width/2 - bar_width/2
      local bar_y = 4
      love.graphics.setColor(red, 40, 40)
      love.graphics.rectangle("fill", bar_x+1, bar_y, bar_size, 8)
      love.graphics.setColor(255, 255, 255)

      local x,y = bar_x, bar_y
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
