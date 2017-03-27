local lg = love.graphics

local scene = require "src/scene"
local dialog = require "src/dialog"
local chip_artist = require "battle/chip_artist"
local chipdb = require(PATHS.chipdb)

local img = lg.newImage(PATHS.battle .. "chips.png")
local sheet = (require "src/quads").multi_sheet{
   img = img,
   bg = {0,0,120,160},
   chipbg = {0,160,16,16,6},
   letter = {0,176,16,8,5},
   button = {0,184,16,16,3},
}

local left = {
   input_index = 1,
   offset = 120,
}
local deck, pal, queue, sel

return {
   transparent = true,
   queue = queue,
   start = function (set, left_deck, right_deck)
      left.deck = left_deck
      left.queue = set.left.queue
      left.pal = left_deck:draw(5, left.pal)
      left.sel = 1
   end,

   update = function (_, input_list)
      local check_queue_valid = function (queue)
         local diff_letter, diff_chip
         for i=2,#queue do
            diff_letter = queue[i].name ~= queue[1].name
            diff_chip = queue[i].ltr ~= queue[1].ltr
         end
         return not (diff_letter and diff_chip)
      end
      local update_side = function (side)
         local input = input_list[side.input_index]
         local sel = side.pal[side.sel]

         if     input.dl==1 then side.sel = (side.sel-1)%6
         elseif input.dr==1 then side.sel = (side.sel+1)%6
         elseif input.a==1 and side.sel==0 then
            scene.pop()
            scene.push(require(PATHS.battle .. "go_screen"))
         elseif input.a==1 and sel then
            table.insert(side.queue, sel) -- Try adding to queue
            if check_queue_valid(side.queue) then
               side.pal[side.sel] = nil -- Complete transaction
            else
               table.remove(side.queue) -- Put it back
            end
         elseif input.b==1 and #side.queue > 0 then
            local i=1
            while(side.pal[i]~=nil) do i=i+1 end
            side.pal[i] = table.remove(side.queue)
         -- elseif input.sel==1 then
         --    local chip = chipdb[sel.name]
         --    scene.push(dialog.popup, chip.desc, 132, 16)
         end
      end
      update_side(left)
   end,

   draw = function ()
      local draw_side = function (side)
         lg.draw(img, sheet.bg, side.offset)

         for i=1,10 do -- Palette
            local x = side.offset + 8 + 16*(i-1%5)
            local y = i<=5 and 104 or 128
            if side.pal[i] then
               chip_artist.draw_icon(side.pal[i].name, x, y)
               local letter = side.pal[i].ltr:byte() - ("a"):byte() + 1
               lg.draw(img, sheet.letter[letter], x, y+16)
            end
            if side.sel==i then
               lg.draw(img, sheet.chipbg[1], x, y)
            end
         end

         for i=1,5 do -- Queue
            local x = 96 + side.offset
            local y = 24 + 16*(i-1)
            if side.queue[i] then
               chip_artist.draw_icon(side.queue[i].name, x, y)
            end
         end

         -- Selectable button
         local button_sel = side.sel==0 and 2 or 1
         lg.draw(img, sheet.button[button_sel], 96 + side.offset, 112)

         -- Art
         local sel = side.pal[side.sel]
         if sel then
            chip_artist.draw_art(sel.name, 8 + side.offset, 16, 1)
            --         local damage = chipdb[sel.name].class.damage
            --         text.draw("flavor", tostring(damage), 8, 88)
         end
      end
      draw_side(left)
   end,
}
