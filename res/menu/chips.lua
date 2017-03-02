local anim = require "src/anim"
local state = require "src/state"
local input = require "src/input"

local sheet = {}

local menu = love.graphics.newImage("res/menu/chips.png")
local w,h = menu:getDimensions()
sheet.bg = anim.sheet(0,0,128,160,1,1,w,h)[1][1]
sheet.button = anim.sheet(128,0,24,16,2,1,w,h)[1]

local chips = love.graphics.newImage("res/battle/chips.png")
local w,h = chips:getDimensions()
sheet.chip = anim.sheet(0,0,16,16,6,1,w,h)[1]
sheet.letter = anim.sheet(0,16,16,8,5,1,w,h)[1]
sheet.art = anim.sheet(0,24,64,120,4,1,w,h)[1]

local lastmod
local palette, queue

local Deck = require "src/Deck"
local chip = require "src/chip"

return {
   start = function (new_lastmod)
      deck = Deck:new(require "res/decks/test")
      lastmod = new_lastmod
      palette = deck:draw(5)
      queue = {}
   end,

   update = function ()
      if input.st==1 then
         state.pop()
      end
   end,

   draw = function ()
      lastmod.draw()
      love.graphics.draw(menu, sheet.bg)

      local x,y

      -- Chip line
      local i=1
      y=104
      for ix=1,2 do
         x=8
         for _=1,5 do
            palchip = palette[i] or 2
            if palette[ix] then
               chip.draw_icon(palette[ix], x, y)
            else
               love.graphics.draw(chips, sheet.chip[2], x, y)
            end
            love.graphics.draw(chips, sheet.letter[1], x, y+16)
            x=x+16
            i=i+1
         end
         y=y+24
      end

      -- Queue
      x,y = 104,24
      for _=1,5 do
         love.graphics.draw(chips, sheet.chip[2], x, y)
         y=y+16
      end
   end,
}
