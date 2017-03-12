local Coord = require "src/Coord"

local depths
local depth_step = 1
local min_depth = -10
local max_depth = 10

local reset = function ()
   depths = {}
   for _ = min_depth, max_depth, depth_step do
      table.insert(depths, {})
   end
end

reset()

return {
   add = function (obj)
      obj.pos = Coord:new(obj.x, obj.y, obj.z)
      local depth = obj.pos.depth
      if depth < min_depth then depth = min_depth end
      if depth > max_depth then depth = max_depth end

      local index = math.floor((depth-min_depth) / depth_step) + 1
      table.insert(depths[index], obj)
   end,

   draw = function ()
      for _,depth in ipairs(depths) do
         for _,v in ipairs(depth) do
            local flip = v.side=="right" and -1 or 1
            local x = v.pos.screen_x - (v.ox or 0)
            local y = v.pos.screen_y - (v.oy or 0)
            if v.frame then
               local row = v.state and v.state.row or v.row or 1
               love.graphics.draw(v.image, v.anim[row][v.frame],
                                  x, y, 0, flip, 1)
            elseif v.image then
               love.graphics.draw(v.image, x, y)
            end
	    if v.draw then v:draw(x, y) end
         end
      end
      reset()
   end,
}
