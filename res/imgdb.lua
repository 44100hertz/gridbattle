--[[
The root of the table defines defaults, each entry a frame or animation.
If there's an intended order to the frames, it goes in "anim".

Base defaults:
x=0, y=0, numx=1, numy=1, anim=false
w,h must be set
--]]

return {
   -- General ------------------------------------
   foldedit = {
      base = {},
      icons = {x=0,  w=16,  h=16, numx=2, numy=7},
      fg    = {x=32, w=224, h=160},
   },
   customize = {
      base = {},
      bg     = {y=0,   w=120, h=160,numx=1},
      chipbg = {y=160, w=16,  h=16, numx=6},
      letter = {y=176, w=16,  h=8,  numx=5},
      button = {y=184, w=16,  h=16, numx=3},
   },
   chip = {
      base = {},
      icon = {y=0, w=16, h=16},
      art  = {y=16, w=64, h=72},
   },

   -- Battle -------------------------------------
   stage = {x=0, y=0, w=40, h=40, numx=2, numy=2},
   battle_ui = {
      base = {},
      bar = {w=8, h=8, numx=3},
   },
   -- Chips --------------------------------------
   bullet = {w=16, h=16, numx=6, anim={1,2,3,4,5,6}},
   boots = {x=0,  y=0, w=24, h=16, numx=2},

   -- Actors -------------------------------------
   ben = {
      base = {w=50, h=60, ox=24, oy=54, anim = {1,2}},
      idle  = {anim = false},
      move  = {y=60,  numx=2, speed=3.5,len=5, iasa=3},
      shoot = {y=120, numx=2, speed=10, len=2, iasa=2},
      throw = {y=180, numx=2, speed=10, len=2, iasa=2},
   },
   tvgirl = {
      base = {w=32, h=48},
      idle  = {y=0,    numx=1},
      shoot = {y=48,   numx=3, speed=10, len=3, anim={1,2,3,3}},
      throw = {y=48*2, numx=3, speed=10, len=3, anim={1,2,3,3}},
      move  = {y=48*3, numx=1, speed=3,  len=8},
   },
}
