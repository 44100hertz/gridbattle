local stage_size = {6, 3}
local stage_offset = {20, 82}
local stage_spacing = {40, 24}
local default_turf = { 3, 3, 3 }
local zero_stage = {
   { 0, 0, 0, 0, 0, 0 },
   { 0, 0, 0, 0, 0, 0 },
   { 0, 0, 0, 0, 0, 0 },
}

local img, floor, turf

stage = {
   init = function ()
      img = img or love.graphics.newImage("stage.png")
      floor = floor or zero_stage
      collision = zero_stage
      turf = turf or default_turf
   end,
   
   draw = function ()
      love.graphics.draw(img)
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
      if stage_x > stage_size[1] or stage_x < 1 then return false end
      if stage_y > stage_size[2] or stage_y < 1 then return false end
      if side==0 and stage_x >  turf[stage_y] then return false end
      if side==1 and stage_x <= turf[stage_y] then return false end
      return true
   end
}
