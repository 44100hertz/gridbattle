local anim = require "src/anim"
local state = require "src/state"
local input = require "src/input"

local sheet = {}

local img = love.graphics.newImage("res/menu/chips.png")
local w,h = img:getDimensions()
local sheet = {
   bg = anim.sheet(0,0,128,160,1,1,w,h)[1][1],
   chipbg = anim.sheet(0,160,16,16,6,1,w,h)[1],
   letter = anim.sheet(0,176,16,8,5,1,w,h)[1],
   button = anim.sheet(0,184,24,16,3,1,w,h)[1],
}

local lastmod
local deck, palette, queue

local Deck = require "src/Deck"
local chip = require "src/chip"
local sel = 1

return {
   start = function (new_lastmod)
      local deckdata = require "res/decks/test"
      deck = Deck:new(deckdata)
      deck:shuffle()
      lastmod = new_lastmod
      palette = deck:draw(5)
      queue = {}
   end,

   update = function ()
      if input.st==1 then
         state.pop()
         return
      end
      if     input.dl==1 then sel = (sel-1)%6
      elseif input.dr==1 then sel = (sel+1)%6
      end
   end,

   draw = function ()
      lastmod.draw()
      love.graphics.draw(img, sheet.bg)

      local x,y

      -- Chip line
      local i=1
      y=104
      for _=1,2 do
         x=8
         for _=1,5 do
            local letter
            if palette[i] then
               chip.draw_icon(palette[i][1], x, y)
               local letter = chip.letter2num[palette[i][2]]
               love.graphics.draw(img, sheet.letter[letter], x, y+16)
            end
            if i==sel then
               love.graphics.draw(img, sheet.chipbg[1], x, y)
            end
            x=x+16
            i=i+1
         end
         y=y+24
      end

      -- Queue
      x,y = 104,24
      for _=1,5 do
         love.graphics.draw(img, sheet.chipbg[2], x, y)
         y=y+16
      end
   end,
}
