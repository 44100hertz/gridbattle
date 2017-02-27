--[[
   All data for a given battle. NOT to be used by any actor.
--]]

return {
   stage = {
      numx=6, numy=3, -- number of platforms
      x=-24, y=74, -- -24 = -32 + 8 (dist from screen edge)
      w=64, h=40, -- size of each platform
      -- stored by loadset: 2d array stage[x][y] such that x and y
      -- are the position of a given platform
   },
   actors = {},
}
