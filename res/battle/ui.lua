local text = require "src/text"

local img = love.graphics.newImage(PATHS.battle .. "ui.png")
local sb = love.graphics.newSpriteBatch(img, 40, "stream")
local sheet = {}
do
   local quads = require "src/quads"
   local w,h = img:getDimensions()
   sheet.bar = quads.sheet(0,0,8,8,3,1,w,h)[1]
end
local bar_width = 128
local bar_x = GAME.width/2 - bar_width/2


return {
   draw_under = function (player, cust_amount, names)
      local full_amt = cust_amount * bar_width
      local bar_size = math.min(full_amt, bar_width-2)

      local red = 40
      if cust_amount >= 1 then
         red = (math.sin(love.timer.getTime()*4 % math.pi)+1) * 100
      end

      -- HP
      if player.hp>0 then
         text.draw("visible", tostring(math.floor(player.hp)), 4, 4)
      end

      -- Enemy names
      text.draw("shadow", names, GAME.width, 2, "right")

      -- Status bar
      local bar_y = 2
      love.graphics.setColor(red, 40, 40)
      love.graphics.rectangle("fill", bar_x+1, bar_y, bar_size, 8)
      love.graphics.setColor(255, 255, 255)

      sb:clear()
      local x,y = bar_x, bar_y
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

   draw_over = function (player)
      if #player.queue > 0 then
	 local top = player.queue[#player.queue].name
	 text.draw("visible", top, 0, GAME.height-11)
      end
   end,
}
