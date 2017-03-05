local scene = require "src/scene"
local input = require "src/input"
local bg = require "src/bg"

local depthdraw = require "src/depthdraw"
local actors = require "src/battle/actors"
local stage = require "src/battle/stage"
local Deck = require "src/Deck"
local deck

-- Some global vars used throughout battle
_G.STAGE = {
   numx = 6,   numy = 3,
   xoff = -20, yoff = 64,
   w = 40,     h = 24,
}

selectchips = function ()
   scene.push(require "res/menu/chips", deck, actors.player.queue)
end

return {
   start = function (set)
      local Deck = require "src/Deck"
      deck = Deck:new(require "res/decks/test")
      deck:shuffle()

      stage.start(set.stage.turf)
      actors.start(set)
      bg.start(set.bg)
   end,

   update = function ()
      if input.st == 1 then
         scene.push((require "src/Menu"):new(require "res/menu/pause"))
      elseif input.l==1 or input.r==1 then
         selectchips()
         return
      end
      actors.update()
      stage.update()
   end,

   draw = function ()
      -- All of these call depthdraw
      bg.draw()
      actors.draw()
      stage.draw()

      depthdraw.draw()
   end,

   selectchips = selectchips,
}
