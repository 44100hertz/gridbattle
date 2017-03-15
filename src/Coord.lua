local xoff, yoff = BATTLE.xoff, BATTLE.yoff
local xscale, yscale = BATTLE.xscale, BATTLE.yscale

local Coord = {}

function Coord:new(x, y, z)
   self = {x=x, y=y, z=z}
   setmetatable(self, Coord)
   return self
end

function Coord:__index (key)
   if key=="screen_x" then
      return xoff + xscale * self.x end
   if key=="screen_y" then
      return yoff + yscale * self.y - self.z end
   if key=="depth" then
      return self.y + self.z / yscale end

   local v = rawget(self, key)
   if key=="x" and self.flip then return GAME.width-v end
   return v
end

return Coord
