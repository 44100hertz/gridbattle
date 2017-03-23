local depths
local depth_step = 1
local min_depth = -10
local max_depth = 10

local xoff, yoff = BATTLE.xoff, BATTLE.yoff
local xscale, yscale = BATTLE.xscale, BATTLE.yscale

local reset = function ()
   depths = {}
   for _ = min_depth, max_depth, depth_step do
      table.insert(depths, {})
   end
end

reset()

return {
   add = function (drawfn, x, y, z)
      local depth = y + z / yscale
      if depth < min_depth then depth = min_depth end
      if depth > max_depth then depth = max_depth end
      local screen_x = xoff + xscale * x
      local screen_y = yoff + yscale * y - z

      local index = math.floor((depth-min_depth) / depth_step) + 1
      table.insert(depths[index], {drawfn, screen_x, screen_y})
   end,

   draw = function ()
      for _,depth in ipairs(depths) do
         for _,v in ipairs(depth) do v[1](v[2], v[3]) end
      end
      reset()
   end,
}
