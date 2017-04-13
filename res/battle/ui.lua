local text = require "src/text"

-- image battle_ui

local bar_width = 128
local bar_x = GAME.width/2 - bar_width/2
local gamewidth = GAME.width

return {
   draw = function (set, cust_amount)
      local full_amt = cust_amount * bar_width
      local bar_size = math.min(full_amt, bar_width-2)

      local draw_enemy_names = function (list, side)
         local names = {}
         for _,v in ipairs(list) do
            if not v.despawn then
               table.insert(names, v.name)
            end
         end
         local x = side=="right" and GAME.width or 0
         text.draw("shadow", names, x, 2, side)
      end
      local draw_hp = function (hp, side)
         local x = side=="right" and gamewidth-4 or 4
         text.draw("visible", tostring(math.floor(hp)), x, 4, side)
      end
      local draw_side = function (kind, side)
         if kind == "player" then
            draw_hp(set[side].hp, side)
         else
            draw_enemy_names(set[side], side)
         end
      end
      draw_side(set.left_kind, "left")
      draw_side(set.right_kind, "right")

      local red = 40
      if cust_amount >= 1 then
         red = (math.sin(love.timer.getTime()*4 % math.pi)+1) * 100
      end

      -- Status bar
      local bar_y = 2
      love.graphics.setColor(red, 40, 40)
      love.graphics.rectangle("fill", bar_x+1, bar_y, bar_size, 8)
      love.graphics.setColor(255, 255, 255)

      local x,y = bar_x, bar_y
      local segs = bar_width/8 - 2
      img:draw("bar", x, y)
      for _=1,segs do
         x = x + 8
         img:draw("bar", x, y)
      end
      x = x + 8
      img:draw("bar", x, y)
      love.graphics.draw(sb)

      local draw_queue_top = function (queue, x)
         if queue and #queue > 0 then
            local top = queue[#queue].name
            text.draw("visible", top, x, GAME.height-11)
         end
      end
      draw_queue_top(set.left.queue, 0)
      draw_queue_top(set.right.queue, GAME.width)
   end,
}
