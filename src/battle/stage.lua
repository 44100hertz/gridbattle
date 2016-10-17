local img = "img/stage.png"

local sheet_data = {
   size = {x=40, y=40},
   strips = {
      left =  { x=0, y=0, num=2 },
      right = { x=0, y=40, num=2 },
   }
}

local sheet = Sheet.new(sheet_data)

local stage_size = {x=6, y=3}
local stage_offset = {x=20, y=82}
local stage_spacing = {x=40, y=24}
local floor, collision, turf = {}, {}, {}

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

local sheet

turf = { 3, 3, 3 }

stage = {
   -- Optional todo: store this to a canvas, and redraw only when needed
   draw = function ()
      local x, y
      for y=1,3 do
	 for x=1,6 do
	    local side = (x>turf[y]) and sheet.left or sheet.right
	    love.graphics.draw(
	       sheet.img, side[floor[y][x]+1],
	       (x-1)*stage_spacing.x, (y-1)*stage_spacing.y+72)
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
