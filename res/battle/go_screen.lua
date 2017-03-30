local resources = require "src/resources"
local rdr = _G.RDR

local length = 30
local ticks

local img, w, h

return {
   transparent = true,
   start = function ()
      img = resources.getimage(PATHS.battle ..  "start.png", "battle")
      _, _, w, h = img:query()
      ticks = 0
   end,
   update = function ()
      local elapsed = ticks / length
      if elapsed >= 1 then
         (require "src/scene"):pop()
      end
      ticks = ticks + 1
   end,
   draw = function ()
      local elapsed = ticks / length
      local ysize = math.sqrt(1 - elapsed) * 3
      local ypos = (1 - ysize) / 2 * h
      rdr:copy(img, {x=0, y=0, w=w, h=h}, {x=0, y=ypos, w=w, h=ysize*h})
   end,
}
