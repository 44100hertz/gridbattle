--[[
### battle-stage ###
 - stores and runs all actors and stage data
 - ALL actor data and functions are exposed here, do nottouch
 - that data is not exposed to the rest of the game
--]]

local stage_size = {x=6, y=3}
local stage_offset = {x=20, y=82}
local stage_spacing = {x=40, y=24}
local img
local quads, floor, collision, turf = {}, {}, {}, {}

floor = {
   { 1, 1, 1, 1, 1, 1 },
   { 1, 1, 1, 1, 1, 1 },
   { 1, 1, 1, 1, 1, 1 },
}
collision = {
   { 0, 0, 0, 0, 0, 0 },
   { 0, 0, 0, 0, 0, 0 },
   { 0, 0, 0, 0, 0, 0 },
}

stage = {
   init = function ()
      img = img or love.graphics.newImage("img/stage.png")
      quads = sheet.generate({x=40, y=40}, {x=2, y=2}, img:getDimensions())
      turf = new_turf or { 3, 3, 3 }      
   end,
      
   -- Optional todo: store this to a canvas, and redraw only when needed
   draw = function ()
      local x, y
      for y=1, 3 do
	 local color=1
	 for x=1, 6 do
	    if x>turf[y] then color=2 end
	    love.graphics.draw(img, quads[color][floor[y][x]+1],
			       (x-1)*40, (y-1)*24+72)
	 end
      end
   end,

   occupy = function (space)
      collision[space.y][space.x] = 1
   end,

   free = function (space)
      collision[space.y][space.x] = 0
   end,

   pos = function (space)
      return {
	 x = stage_offset.x + stage_spacing.x * (space.x-1),
	 y = stage_offset.y + stage_spacing.y * (space.y-1)
      }
   end,
   
   canGo = function (space, side)
      if (space.x > stage_size.x or space.x < 1) or
	 (space.y > stage_size.y or space.y < 1) or
	 (floor[space.y][space.x]==0) or
	 (collision[space.y][space.x]==1) or
	 (side=="left" and space.x >  turf[space.y]) or
	 (side=="right" and space.x <= turf[space.y])	 
      then
	 return false
      else
	 return true
      end
   end
}

return stage
