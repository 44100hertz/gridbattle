local tform = {}
local depths
local depth_step = 1
local min_depth
local max_depth

local reset = function ()
   min_depth, max_depth = 1000,-1000
   depths = {}
end

reset()

return {
   tform = tform,
   add = function (drawfn, x, y, z)
      local depth = y + z / tform.yscale
      local index = math.floor(depth / depth_step) + 1
      local screen_x = tform.xoff + tform.xscale * x
      local screen_y = tform.yoff + tform.yscale * y - z

      if index < min_depth then min_depth = index end
      if index > max_depth then max_depth = index end

      if not depths[index] then depths[index] = {} end
      table.insert(depths[index], {drawfn, screen_x, screen_y})
   end,

   draw = function ()
      for i = min_depth, max_depth, depth_step do
         depth = depths[i]
         if depth then
            for _,v in ipairs(depth) do
               v[1](math.floor(v[2]), math.floor(v[3]))
            end
         end
      end
      reset()
   end,
}
