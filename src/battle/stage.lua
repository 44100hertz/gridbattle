local img = love.graphics.newImage("img/stage.png")

local sheet_data = {
   size = {x=40, y=40},
   img_size = {x=240, y=160},
   strips = {
      left =  { x=0, y=0, num=2 },
      right = { x=0, y=40, num=2 },
   }
}

local sheet = Sheet.new(sheet_data)
local floor = {
   { 1, 1, 1, 1, 1, 1 },
   { 1, 1, 1, 1, 1, 1 },
   { 1, 1, 1, 1, 1, 1 },
}
local collision = {
   { 0, 0, 0, 0, 0, 0 },
   { 0, 0, 0, 0, 0, 0 },
   { 0, 0, 0, 0, 0, 0 },
}
local turf = { 3, 3, 3 }

stage = {
   size = {x=6, y=3},
   offset = {x=20, y=82},
   spacing = {x=40, y=24},

   -- Optional todo: store this to a canvas, and redraw only when needed
   draw = function ()
      local x, y
      for y=1,3 do
	 for x=1,6 do
	    local side = (x>turf[y]) and sheet.left or sheet.right
	    love.graphics.draw(
	       img, side[floor[y][x]+1],
	       (x-1)*stage.spacing.x, (y-1)*stage.spacing.y+72)
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
	 x = stage.offset.x + stage.spacing.x * (space.x-1),
	 y = stage.offset.y + stage.spacing.y * (space.y-1)
      }
   end,
   
   canGo = function (space, side)
      if (space.x > stage.size.x or space.x < 1) or
	 (space.y > stage.size.y or space.y < 1) or
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
