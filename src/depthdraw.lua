local data = require "src/battle/data"

local depths
local levels = 8
local depth_step = 20
local min_depth = -100
local max_depth = 100

reset = function ()
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
            local screen_x = data.stage.x + data.stage.w * v.x -
               (v.ox or 0)
            local screen_y = data.stage.y + data.stage.h * v.y -
               v.z - (v.oy or 0) - (v.height or 0)

            -- if screen_x < -20 or screen_x > 420 or screen_y < -20 then
            --    v.despawn = true
            --    return
            -- end

            if v.draw then v:draw(screen_x, screen_y) end
            if v.frame then
               love.graphics.draw(v.image, v.anim[v.frame], screen_x, screen_y)
            elseif v.image then
               love.graphics.draw(v.image, screen_x, screen_y)
            end
         end
      end
      reset()
   end,
}
