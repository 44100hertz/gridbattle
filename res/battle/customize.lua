local scene = require "src/scene"
local dialog = require "src/dialog"

local lg = love.graphics

local chip_artist = require "battle/chip_artist"
local chipdb = require(PATHS.chipdb)

local img = lg.newImage(PATHS.battle .. "chips.png")
local sheet = (require "src/quads").multi_sheet{
   img = img,
   bg = {0,0,128,160},
   chipbg = {0,160,16,16,6},
   letter = {0,176,16,8,5},
   button = {0,184,24,16,3},
}

local deck, pal, queue, sel

return {
   transparent = true,
   queue = queue,
   start = function (_deck, set)
      deck = _deck
      queue = set.left.queue
      for i,_ in ipairs(queue) do queue[i] = nil end
      sel = 1
      pal = deck:draw(5, pal)
   end,

   update = function (_, input)
      input = input[1]
      if     input.dl==1 then sel = (sel-1)%6
      elseif input.dr==1 then sel = (sel+1)%6
      elseif input.a==1 then
         -- don't try to insert nothing
         if sel==0 then
            scene.pop()
            scene.push(require(PATHS.battle .. "go_screen"))
         elseif pal[sel] then
            table.insert(queue, pal[sel])
            local diff_letter, diff_chip
            for i=2,#queue do
               diff_letter = queue[i].name ~= queue[1].name
               diff_chip = queue[i].ltr~=queue[1].ltr
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
         local chip = chipdb[pal[sel].name]
         scene.push(dialog.popup, chip.desc, 132, 16)
      end
   end,

   draw = function ()
      lg.draw(img, sheet.bg)

      local x,y

      -- Chip line
      local i=1
      y=104
      for _=1,2 do
         x=8
         for _=1,5 do
            if pal[i] then
               chip_artist.draw_icon(pal[i].name, x, y)
               local letter = pal[i].ltr:byte() - ("a"):byte() + 1
               lg.draw(img, sheet.letter[letter], x, y+16)
            end
            if sel==i then
               lg.draw(img, sheet.chipbg[1], x, y)
            end
            x=x+16
            i=i+1
         end
      end

      -- Queue
      x,y = 104,24
      for i=1,5 do
         if queue[i] then
            chip_artist.draw_icon(queue[i].name, x, y)
         end
         y=y+16
      end

      -- Selectable button
      local button_sel = sel==0 and 2 or 1
      lg.draw(img, sheet.button[button_sel], 96, 112)

      -- Art
      if pal[sel] then
         chip_artist.draw_art(pal[sel].name, 8, 16, 1)
--         local damage = chipdb[pal[sel].name].class.damage
--         text.draw("flavor", tostring(damage), 8, 88)
      end
   end,
}
