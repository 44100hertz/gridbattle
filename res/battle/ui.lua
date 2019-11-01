local text = require 'src/text'

local img = (require'src/image').new'battle_ui'
local bar_width = 128
local bar_x = GAME.width/2 - bar_width/2
local gamewidth = GAME.width

local ui = {}

function ui.draw (set, cust_amount)
   -- Side-specific information
   for i = 1,2 do
      local side = set.sides[i]
      if side.is_player then
         -- For player: HP in upper corner
         local hp = side[1].hp
         local x = i==2 and gamewidth-4 or 4
         text.draw('visible', tostring(math.floor(hp)), x, 4, side)
         -- Queue top in lower corner
         if side.queue and #side.queue > 0 then
            local top = side.queue[#side.queue].name
            local x = i == 1 and 0 or GAME.width
            text.draw('visible', top, x, GAME.height-11)
         end
      else
         -- For enemies: Enemy names in upper corner
         local names = {}
         for _,v in ipairs(side) do
            if not v.despawn then
               table.insert(names, v.name)
            end
         end
         local x = i==2 and GAME.width or 0
         text.draw('shadow', names, x, 2, i)
      end
   end

   -- Customize bar
   local full_amt = cust_amount * bar_width
   local bar_size = math.min(full_amt, bar_width-2)
   local red = 40
   if cust_amount >= 1 then
      red = (math.sin(love.timer.getTime()*4 % math.pi)+1) * 100/256.0
   end
   local bar_y = 2
   love.graphics.setColor(red, 40/256.0, 40/256.0)
   love.graphics.rectangle('fill', bar_x+1, bar_y, bar_size, 8)
   love.graphics.setColor(255, 255, 255)
   local x,y = bar_x, bar_y
   local segs = bar_width/8 - 2
   img:set_sheet('bar')
   img:draw(x, y, nil, 1)
   for _=1,segs do
      x = x + 8
      img:draw(x, y, nil, 2)
   end
   x = x + 8
   img:draw(x, y, nil, 3)
end

return ui
