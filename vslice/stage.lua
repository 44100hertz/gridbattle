assert "sheet"

local stage_size = {6, 3}
local stage_offset = {20, 82}
local stage_spacing = {40, 24}
local img, quads, floor, collision, turf

stage = {
   init = function (new_floor, new_collision, new_turf)
      img = img or love.graphics.newImage("stage.png")
      quads = sheet.generate(40, 40, 2, 2, img:getDimensions())
      floor = new_floor or {
	 { 1, 1, 1, 1, 1, 1 },
	 { 1, 1, 1, 1, 1, 1 },
	 { 1, 1, 0, 1, 1, 1 },
		       }
      collision = new_collision or {
	 { 1, 1, 1, 1, 1, 1 },
	 { 1, 1, 1, 1, 1, 1 },
	 { 1, 1, 1, 1, 1, 1 },
		       }
      turf = new_turf or { 3, 4, 5 }
   end,

   -- Optional todo: store this to a canvas, and redraw only when needed
   draw = function ()
      local x, y
      for y=1, 3 do
	 local color_offset = 0
	 for x=1, 6 do
	    if x>turf[y] then color_offset = 2 end
	    love.graphics.draw(img, quads[color_offset + floor[y][x] + 1],
			       (x-1)*40, (y-1)*24+72)
	 end
      end
   end,

   occupy = function (stage_x, stage_y)
      collision[stage_y][stage_x] = 1
   end,

   free = function (stage_x, stage_y)
      collision[stage_y][stage_x] = 0
   end,

   position = function (stage_x, stage_y)
      local x = stage_offset[1] + stage_spacing[1] * (stage_x-1)
      local y = stage_offset[2] + stage_spacing[2] * (stage_y-1)
      return x,y
   end,
   
   canGo = function (stage_x, stage_y, side)
      if (stage_x > stage_size[1] or stage_x < 1) or
	 (stage_y > stage_size[2] or stage_y < 1) or
	 (floor[stage_y][stage_x]==0) or
	 (side==0 and stage_x >  turf[stage_y]) or
	 (side==1 and stage_x <= turf[stage_y])
      then return false
      end
      return true
   end
}
