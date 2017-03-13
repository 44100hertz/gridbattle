local chip = require "src/chip"
local text = require "src/text"

local lg = love.graphics

local col, sel
local collection = require "res/test-collection"
local num_entries = 12
local entry_height = 11
local pane_left = {}
local pane_right = {}

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

return {
   start = function ()
      col, sel = 2,1
      pane_left.sel = 1
      pane_right.sel = 1
   end,

   update = function (_, input)
      -- Check input with repeat
      local repcheck = function (t)
         return t % math.max(30-t, 4) == 1
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
         if repcheck(input.dd) then
            pane_left.sel = pane_left.sel % #collection + 1
         elseif repcheck(input.du) then
            pane_left.sel = (pane_left.sel-2) % #collection + 1
         end
      end
   end,

   draw = function ()
      lg.clear(0,0,0)
      local y = 19
      local i = pane_left.sel - 5
      for _ = 1, num_entries do
         local v = collection[i]
         if not v then
            v = collection[(i-1) % #collection+1]
            lg.setColor(128, 128, 128)
         end
         -- Highlight selection
         if i == pane_left.sel then lg.setColor(120, 192, 128) end

         text.draw("flavor", v.name, 24, y)
         lg.setColor(255, 255, 255)
         y = y + entry_height
         i = i + 1
      end

      lg.draw(img, sheet.fg)

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
