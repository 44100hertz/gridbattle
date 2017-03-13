local col, sel
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
   [1] = function () scene.pop() end,
}

return {
   start = function ()
      col, sel = 2,1
   end,
   update = function (_, input)
      if input.dr==1 then col = col%3+1 return end
      if input.dl==1 then col = (col-2)%3+1 return end
      if col==1 and input.a==1 then col1[sel]() return end
   end,
   draw = function ()
      love.graphics.draw(img, sheet.fg)
      for i,v in ipairs(sheet.icons) do
         is_sel = (col==1 and sel==i) and 2 or 1
         love.graphics.draw(img, sheet.icons[i][is_sel], 0, i*16)
      end
   end,
}
