local anim = require "src/anim"
local scene = require "src/scene"
local input = require "src/input"
local dialog = require "src/dialog"
local chip = require "src/chip"
local text = require "src/text"

local sheet = {}

local img = love.graphics.newImage("res/battle/chips.png")
local w,h = img:getDimensions()
local sheet = {
   bg = anim.sheet(0,0,128,160,1,1,w,h)[1][1],
   chipbg = anim.sheet(0,160,16,16,6,1,w,h)[1],
   letter = anim.sheet(0,176,16,8,5,1,w,h)[1],
   button = anim.sheet(0,184,24,16,3,1,w,h)[1],
}

local deck, pal, queue, sel

return {
   transparent = true,
   start = function (new_deck, new_queue)
      deck = new_deck
      queue = new_queue
      for i,_ in ipairs(queue) do queue[i] = nil end

      letter = nil
      sel = 1
      pal = deck:draw(5, pal)
   end,

   update = function (_, input)
      if     input.dl==1 then sel = (sel-1)%6
      elseif input.dr==1 then sel = (sel+1)%6
      elseif input.a==1 then
         -- don't try to insert nothing
         if sel==0 then
            scene.pop()
         elseif pal[sel] then
            table.insert(queue, pal[sel])
            local diff_letter, diff_chip
            for i=2,#queue do
               if queue[i][1]~=queue[1][1] or
                  queue[i][2]~=queue[1][2]
               then
                  diff_letter=true
               end
               if queue[i].ltr~=queue[1].ltr then diff_chip=true end
            end
            if not (diff_letter and diff_chip) then
               pal[sel] = nil
            else
               table.remove(queue)
            end
         end
      elseif input.b==1 then
         -- don't try to remove empty
         if #queue==0 then return end
         -- find an empty palette slot
         local i=1
         while(pal[i]~=nil) do i=i+1 end
         pal[i] = table.remove(queue)
      elseif input.sel==1 then
         local chip = chip.getchip(pal[sel].name)
         scene.push(dialog.popup, chip.src.desc, 132, 16)
      end
   end,

   draw = function ()
      love.graphics.draw(img, sheet.bg)

      local x,y

      -- Chip line
      local i=1
      y=104
      for _=1,2 do
         x=8
         for _=1,5 do
            local letter
            if pal[i] then
               chip.draw_icon(pal[i].name, x, y)
               local letter = chip.letter2num[pal[i].ltr]
               love.graphics.draw(img, sheet.letter[letter], x, y+16)
            end
            if sel==i then
               love.graphics.draw(img, sheet.chipbg[1], x, y)
            end
            x=x+16
            i=i+1
         end
      end

      -- Queue
      x,y = 104,24
      for i=1,5 do
         if queue[i] then
            chip.draw_icon(queue[i].name, x, y)
         end
         y=y+16
      end

      -- Selectable button
      button_sel = sel==0 and 2 or 1
      love.graphics.draw(img, sheet.button[button_sel], 96, 112)
      y=y+24

      -- Art
      if pal[sel] then
         chip.draw_art(pal[sel].name, 8, 16, 1)
         local damage = chip.getchip(pal[sel].name).src.ent.damage
         text.draw("flavor", tostring(damage), 8, 88)
      end
   end,

   queue=queue,
}
