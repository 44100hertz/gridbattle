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
   yoff = 60,
}

return {
   start = function ()
      (require"src/scene").push(require"battle/battle", "empty", "empty")
   end
}
