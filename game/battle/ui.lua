local oop = require 'src/oop'
local image = require 'src/image'

local bar_width = 128

local ui = oop.class()

function ui:init ()
   self.image = image('battle/ui')
end

function ui:draw (set, cust_amount)
--    for i = 1,2 do
--       local side = set.sides[i]
--       local align = i == 1 and 'left' or 'right'
--       if side.is_player then
--          -- For player: HP in upper corner
--          local hp = side[1].hp:get()
--          local x = i==2 and GAME.size.x-4 or 4
--          love.graphics.print(tostring(math.floor(hp)), x, 4)
--          -- Queue top in lower corner
-- --         if side.queue and #side.queue > 0 then
-- --            local top = side.queue[#side.queue].name
-- --            love.graphics.printf(top, 0, GAME.size.y-11, GAME.size.x, align)
-- --         end
--       else
--          -- For enemies: Enemy names in upper corner
--          local names = {}
--          for _,v in ipairs(side) do
--             if not v.despawn then
--                table.insert(names, v.name)
--             end
--          end
--          for j = 1,#names do
--             love.graphics.printf(names[j], 0,  j*20, GAME.size.x, align)
--          end
--       end
--    end

   -- Customize bar
   local full_amt = cust_amount * bar_width
   local bar_size = math.min(full_amt, bar_width-2)
   local red = 40
   if cust_amount >= 1 then
      red = (math.sin(love.timer.getTime()*4 % math.pi)+1) * 100/256.0
   end
   local bar_x = GAME.size.x/2 - bar_width/2
   local bar_y = 2
   love.graphics.setColor(red, 40/256.0, 40/256.0)
   love.graphics.rectangle('fill', bar_x+1, bar_y, bar_size, 8)
   love.graphics.setColor(255, 255, 255)
   local x,y = bar_x, bar_y
   local segs = bar_width/8 - 2
   self.image:set_sheet('bar')
   self.image:draw(x, y, nil, 1)
   for _=1,segs do
      x = x + 8
      self.image:draw(x, y, nil, 2)
   end
   x = x + 8
   self.image:draw(x, y, nil, 3)
end

return ui
