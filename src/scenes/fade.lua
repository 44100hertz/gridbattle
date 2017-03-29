local rdr = _G.RDR
local fillrect = {x=0, y=0, w=GAME.width, h=GAME.height}

local is_in, length, ticks

return {
   transparent = true,
   start = function (_length, _is_in, _after)
      is_in, after = _is_in, _after
      length = GAME.tickrate * _length
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
      if is_in then darkness = 255 - darkness end

      rdr:setDrawColor(0x000000)
      rdr:fillRect{fillrect}
   end,
}
