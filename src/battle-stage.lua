local stage_size = {x=6, y=3}
local stage_offset = {x=20, y=82}
local stage_spacing = {x=40, y=24}
local img
local quads, floor, collision, turf = {}, {}, {}, {}

stage = {
   init = function (new_floor, new_collision, new_turf)
      img = img or love.graphics.newImage("img/stage.png")
      quads = sheet.generate({x=40, y=40}, {x=2, y=2}, img:getDimensions())
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
	 local color=1
	 for x=1, 6 do
	    if x>turf[y] then color=2 end
	    love.graphics.draw(img, quads[color][floor[y][x]+1],
			       (x-1)*40, (y-1)*24+72)
	 end
      end
   end,

   occupy = function (s_pos)
      collision[s_pos] = 1
   end,

   free = function (s_pos)
      collision[s_pos] = 0
   end,

   pos = function (s_pos)
      return {
	 x = stage_offset.x + stage_spacing.x * (s_pos.x-1),
	 y = stage_offset.y + stage_spacing.y * (s_pos.y-1)
      }
   end,
   
   canGo = function (s_pos, side)
      if (s_pos.x > stage_size.x or s_pos.x < 1) or
	 (s_pos.y > stage_size.y or s_pos.y < 1) or
	 (floor[s_pos.y][s_pos.x]==0) or
	 (side=="left" and s_pos.x >  turf[s_pos.y]) or
	 (side=="right" and s_pos.x <= turf[s_pos.y])
      then
	 return false
      else
	 return true
      end
   end
}
