local tform = {}
local depths
local depth_step = 1
local min_depth
local max_depth

local reset = function ()
   min_depth, max_depth = 0,0
   depths = {}
   for _ = min_depth, max_depth, depth_step do
      table.insert(depths, {})
   end
end

reset()

return {
   tform = tform,
   add = function (drawfn, x, y, z)
      local depth = y + z / tform.yscale
      if depth < min_depth then min_depth = depth end
      if depth > max_depth then max_depth = depth end
      local screen_x = tform.xoff + tform.xscale * x
      local screen_y = tform.yoff + tform.yscale * y - z

      local index = math.floor(depth / depth_step) + 1
      if not depths[index] then depths[index] = {} end
      table.insert(depths[index], {drawfn, screen_x, screen_y})
   end,

   draw = function ()
      for i = min_depth+1, max_depth+1, depth_step do
         depth = depths[i]
         if depth then
            for _,v in ipairs(depth) do v[1](v[2], v[3]) end
         end
      end
      reset()
   end,
}
