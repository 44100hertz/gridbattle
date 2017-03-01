local anim = require "src/anim"
local state = require "src/state"
local input = require "src/input"

local img = love.graphics.newImage("res/battle/chips.png")
local w,h = img:getDimensions()

local sheet = {
   bg = anim.sheet(0,0,128,160,1,1,w,h)[1][1],
   button = anim.sheet(128,0,24,16,2,1,w,h)[1],
   chip = anim.sheet(128,16,16,16,6,1,w,h)[1],
   letter = anim.sheet(128,32,16,8,5,1,w,h)[1],
   art = anim.sheet(0,160,64,120,4,1,w,h)[1],
}

local lastmod
return {
   start = function (new_lastmod)
      lastmod = new_lastmod
   end,

   update = function ()
      if input.st==1 then
         state.pop()
      end
   end,

   draw = function ()
      lastmod.draw()
      love.graphics.draw(img, sheet.bg)

      local x,y

      -- Chip line
      y=104
      for _=1,2 do
         x=8
         for _=1,5 do
            love.graphics.draw(img, sheet.chip[2], x, y)
            love.graphics.draw(img, sheet.letter[1], x, y+16)
            x=x+16
         end
         y=y+24
      end

      -- Queue
      x,y = 104,24
      for _=1,5 do
         love.graphics.draw(img, sheet.chip[2], x, y)
         y=y+16
      end
   end,
}
