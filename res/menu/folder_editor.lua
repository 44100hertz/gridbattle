local chip = require "src/chip"
local text = require "src/text"

local col, sel
local collection = require "res/test-collection"
local entry_height = 11

local img = love.graphics.newImage("res/menu/editor.png")
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
   end,

   update = function (_, input)
      if input.dr==1 then col = col%3+1 return end
      if input.dl==1 then col = (col-2)%3+1 return end
      if col==1 then
         if input.a==1 then col1[sel]() return end
         if input.du==1 then sel = sel % #col1 + 1 return end
         if input.dd==1 then sel = (sel-2) % #col1 + 1 return end
      end
   end,

   draw = function ()
      love.graphics.clear(0,0,0)
      local y = 16
      for i,v in ipairs(collection) do
         text.draw("flavor", v.name, 24, y)
         y = y + entry_height
      end

      love.graphics.draw(img, sheet.fg)

      -- Selection rectangle around column
      local draw_col_sel = function (x, selected)
         love.graphics.setColor(120, 192, 128)
         love.graphics.rectangle("line", x+1.5, 1.5, 109, 157)
         love.graphics.setColor(255, 255, 255)
      end
      if col==2 then draw_col_sel(16) end
      if col==3 then draw_col_sel(128) end

      -- Icons on left
      for i,v in ipairs(sheet.icons) do
         is_sel = (col==1 and sel==i) and 2 or 1
         love.graphics.draw(img, sheet.icons[i][is_sel], 0, i*16)
      end
   end,
}
