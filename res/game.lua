_G.GAME = {
   width = 240,
   height = 160,
   tickrate = 60,
}

_G.BATTLE = {
   numx = 6,
   numy = 3,
   xscale = 40,
   yscale = 24,
}

-- Keep the stage centered based on the current screen res
_G.BATTLE.xoff = math.floor(GAME.width/2 - (BATTLE.xscale * (BATTLE.numx + 1) * 0.5))
_G.BATTLE.yoff = 64 + 0.5 * (GAME.height-160)

return {
   start = function ()
      (require "src/scene").push((require "src/Menu"):new("title"))
   end,
}
