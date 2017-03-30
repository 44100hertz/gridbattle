local SDL = require "SDL"
local rdr = _G.RDR

local is_in, length, ticks, after
local screenrect = {x=0, y=0, w=_G.GAME.width, h=_G.GAME.height}

return {
   transparent = true,
   start = function (_length, _is_in, _after)
      is_in, after = _is_in, _after
      length = _G.GAME.tickrate * _length
      ticks = 0
   end,

   update = function ()
      if ticks > length then
         after()
      end
      ticks = ticks + 1
   end,

   draw = function ()
      local darkness = 255 * ticks / length
      if darkness > 255 then darkness = 255 end
      if not is_in then darkness = 255 - darkness end

      rdr:setDrawBlendMode(SDL.blendMode.Mod)
      rdr:setDrawColor{r=darkness, g=darkness, b=darkness}
      rdr:fillRect(screenrect)
      rdr:setDrawBlendMode(SDL.blendMode.None)
   end,
}
