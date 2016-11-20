--[[
When game is running, contains an array stage[x][y]
such that x and y are a given position that point to a loaded panel data
--]]

return {
   width=6, height=3,
   offset = {x=-24, y=74}, -- -24 = -32 + 8 (dist from screen edge)
   spacing = {x=64, y=40},

   getpanel = function (self, x, y)
      x,y = math.floor(x+0.5), math.floor(y+0.5)
      if self[x] and self[x][y] then
	 return self[x][y]
      end
   end
}
