local oop = require 'src/oop'
local image = require 'src/image'

local scene = require 'src/scene'

local results = {
   transparent = true,
   open = true,
}

function results:new (result)
   local self = oop.instance(results, {})
   self.image = image.new('battle/results')
   self.frame = result
   return self
end

function results:update (input)
   if input[1].a==1 then
      scene.pop()
      scene.pop()
   end
end

function results:draw ()
   self.image:draw(0, 0, nil, self.frame)
end

return results
