local Folder = require "src/Folder"
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

local move_chip = function (from, to)
   local entry = from.folder:remove(from.sel)
   if not entry then return end
   if not from.folder[from.sel] then
      if from.sel < #from.folder then
         from.sel = from.sel + 1
      else
         from.sel = math.max(#from.folder, 1)
      end
   end
   to.folder:insert(entry)
end

local pane_left = {
   folder = Folder:new(require "res/test-collection"),
}
local pane_right = {
   folder = Folder:new(require "res/folders/test"),
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
         if #pane.folder==0 then return end
         if repcheck(input.dd) then
            pane.sel = pane.sel % #pane.folder + 1
         elseif repcheck(input.du) then
            pane.sel = (pane.sel-2) % #pane.folder + 1
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
         if input.a==1 then
            move_chip(pane_left, pane_right)
         end
      elseif col==3 then
         update_pane(pane_right)
         if input.a==1 then
            move_chip(pane_right, pane_left)
         end
      end
   end,

   draw = function ()
      lg.clear(16,24,24)

      local draw_list = function (pane, x)
         if #pane.folder==0 then return end
         local y = 19
         local i = pane.sel - 5
         for _ = 1, num_entries do
            local v = pane.folder[i]
            if not v then
               v = pane.folder[(i-1) % #pane.folder+1]
               lg.setColor(136,144,136)
            end
            -- Highlight selection
            if i == pane.sel then lg.setColor(120, 192, 128) end

            text.draw("flavor", v.ltr:upper(), x, y)
            text.draw("flavor", v.name, x+22, y)
            text.draw("flavor", "\127" .. v.qty, x+78, y)
            lg.setColor(255, 255, 255)
            y = y + entry_height
            i = i + 1
         end
      end

      draw_list(pane_left, 24)
      draw_list(pane_right, 136)

      lg.draw(img, sheet.fg)
      text.draw("flavor", "Collection", 24, 8)
      local right_str = "Folder (" .. pane_right.folder:count() .. "/30" .. ")"
      text.draw("flavor", right_str, 136, 8)

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
