local depths
local levels = 8
local depth_step = 20
local min_depth = -100
local max_depth = 100

local reset = function ()
   depths = {}
   for i = min_depth, max_depth, depth_step do
      table.insert(depths, {})
   end
end

reset()

return {
   add = function (obj)
      local depth = obj.y+(obj.z/40)
      if depth < min_depth then depth = min_depth end
      if depth > max_depth then depth = max_depth end

      local index = math.floor((depth-min_depth) / depth_step) + 1
      table.insert(depths[index], obj)
   end,

   draw = function ()
      for _,depth in ipairs(depths) do
         for _,v in ipairs(depth) do
            local screen_x = STAGE.xoff + STAGE.w * v.x - (v.ox or 0)
            local screen_y = STAGE.yoff + STAGE.h * v.y - v.z - (v.oy or 0)

            if v.draw then v:draw(screen_x, screen_y) end
            if v.frame then
               local row = v.state and v.state.row or (v.row or 1)
               love.graphics.draw(v.image, v.anim[row][v.frame], screen_x, screen_y)
            elseif v.image then
               love.graphics.draw(v.image, screen_x, screen_y)
            end
         end
      end
      reset()
   end,
}
