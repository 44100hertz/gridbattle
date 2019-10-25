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
      icons = {x=0,  w=16,  h=16, numx=2, numy=7},
      fg    = {x=32, w=224, h=160},
   },
   customize = {
      bg     = {y=0,   w=120, h=160,numx=1},
      chipbg = {y=160, w=16,  h=16, numx=6},
      letter = {y=176, w=16,  h=8,  numx=5},
      button = {y=184, w=16,  h=16, numx=3},
   },
   chip = {
      icon = {y=0, w=16, h=16},
      art  = {y=16, w=64, h=72},
   },

   -- Battle -------------------------------------
   panels = {base = {x=0, y=0, w=40, h=40, ox=20, oy=28, numx=2, numy=2}},
   battle_ui = {
      bar = {w=8, h=8, numx=3},
   },
   -- Chips --------------------------------------
   bullet = {base = {ox=8, oy=8, w=16, h=16, numx=6, anim={1,2,3,4,5,6}, fps=20}},
   boots = {base = {x=0, y=0, w=24, h=16, numx=2}},
   wheel_crate = {base = {ox=17, oy=45}},

   -- Actors -------------------------------------
   testenemy = {base = {ox=22, oy=50}},
   testenemy2 = {base = {ox=22, oy=50}},
   ben = {
      base  = {w=50, h=60, ox=24, oy=54, anim = false},
      move  = {y=60,  w=50, h=60, ox=24, oy=54, fps=20, numx=2,
               len=3, iasa=3, anim={1,2}},
      shoot = {y=120, w=50, h=60, ox=24, oy=54, fps=20, numx=2,
               len=5, iasa=3, anim={1,2}},
      throw = {y=180, w=50, h=60, ox=24, oy=54, fps=20, numx=2,
               len=5, iasa=3, anim={1,2}},
   },
}
