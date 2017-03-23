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
   -- xoff is calculated
   yoff = 62 + 0.5 * (GAME.height-160),
}

return {
   start = function ()
      (require "src/scene").push((require "src/Menu"):new("title"))
   end,
}
