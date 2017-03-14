local chip = require "src/chip"
local text = require "src/text"

local lg = love.graphics

local img = lg.newImage("res/menu/editor.png")
local sheet = {}
do
   local anim = require "src/anim"
   local w,h = img:getDimensions()
   sheet.fg = anim.sheet(0,0,240,160,1,1,w,h)[1][1]
   sheet.icons = anim.sheet(0,160,16,16,2,2,w,h)
end

local scene = require "src/scene"
local col1 = {
   [1] = scene.pop,
   [2] = function () print("saving...") end,
}

local col, sel
local num_entries = 12
local entry_height = 11

local folder_to_list = function (folder)
   local list = {}
   for _,folder_entry in ipairs(folder) do
      local i, entry
      -- Check if entry already exists
      for i=1,#list do
         if list[i].name == folder_entry[1] and
            list[i].ltr == folder_entry.ltr
         then
            entry = list[i]
            break
         end
      end
      -- Make new entry
      if not entry then
         entry = {name = folder_entry[1],
                  ltr = folder_entry.ltr,
                  qty = 0}
         table.insert(list, entry)
      end
      entry.qty = entry.qty + 1
   end
   return list
end

local pane_left = {
   list = require "res/test-collection",
}
local pane_right = {
   list = folder_to_list(require "res/folders/test")
}

return {
   start = function ()
      col, sel = 2,1
      pane_left.sel = 1
      pane_right.sel = 1
   end,

   update = function (_, input)
      -- Check input with repeat
      local repcheck = function (t)
         return t % math.max(20-t, 6) == 1
      end
      local update_pane = function (pane)
         if repcheck(input.dd) then
            pane.sel = pane.sel % #pane.list + 1
         elseif repcheck(input.du) then
            pane.sel = (pane.sel-2) % #pane.list + 1
         end
      end

      if input.dr==1 then col = col%3+1 return end
      if input.dl==1 then col = (col-2)%3+1 return end

      if col==1 then
         if input.a==1 then
            col1[sel]()
         elseif input.du==1 then
            sel = sel % #col1 + 1
         elseif input.dd==1 then
            sel = (sel-2) % #col1 + 1
         end
      elseif col==2 then
         update_pane(pane_left)
      elseif col==3 then
         update_pane(pane_right)
      end
   end,

   draw = function ()
      lg.clear(16,24,24)

      local draw_list = function (pane, x)
         local y = 19
         local i = pane.sel - 5
         for _ = 1, num_entries do
            local v = pane.list[i]
            if not v then
               v = pane.list[(i-1) % #pane.list+1]
               lg.setColor(88,96,96)
            end
            -- Highlight selection
            if i == pane.sel then lg.setColor(120, 192, 128) end

            text.draw("flavor", v.ltr:upper(), x, y)
            text.draw("flavor", v.name, x+22, y)
            text.draw("flavor", "\127" .. v.qty, x+84, y)
            lg.setColor(255, 255, 255)
            y = y + entry_height
            i = i + 1
         end
      end

      draw_list(pane_left, 24)
      draw_list(pane_right, 136)

      lg.draw(img, sheet.fg)
      text.draw("flavor", "Collection", 24, 8)
--      local right_str = "Folder (" .. #pane_right.list .. "/30" .. ")"
      text.draw("flavor", "Folder", 136, 8)

      -- Selection rectangle around column
      local draw_col_sel = function (x, selected)
         lg.setColor(120, 192, 128)
         lg.rectangle("line", x+1.5, 1.5, 109, 157)
         lg.setColor(255, 255, 255)
      end
      if col==2 then draw_col_sel(16) end
      if col==3 then draw_col_sel(128) end

      -- Icons on left
      for i,v in ipairs(sheet.icons) do
         is_sel = (col==1 and sel==i) and 2 or 1
         lg.draw(img, sheet.icons[i][is_sel], 0, i*16)
      end
   end,
}
