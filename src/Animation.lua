--[[ Animation
An animation is just a list of values, e.g.
anim.idle = {0,0,0,0,1,1,1,1}
which would be data.idle.timing = {4,4}, data.idle.order = {0,1} as input
--]]

Animation = {}

local function getLine (timing, order)
   local line = {}
   local time = 1 -- absolute frame number
   local count = 1 -- where in timing/order
   while(timing[count]) do
      frame = order[count] or frame+1 -- increment by default
      for time = time, time + timing[count]-1 do -- minus 1 for offset, not index
	 line[time] = frame
      end
      count = count + 1
   end
   return line
end

function Animation.new(data)
   local anim = {}
   for k,_ in pairs(data) do
      anim[k] = getLine(data[k].timing, data[k].order)
   end
   return anim
end
