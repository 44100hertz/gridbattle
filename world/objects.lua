local oop = require 'src/oop'
local point = require 'src/point'

local objects = oop.class()

function objects:init (data)
   self.objects = {}

   for _,layer in ipairs(data.layers) do
      if layer.type == 'objectgroup' then
         for _,object in ipairs(layer.objects) do
            self.objects[#self.objects+1] = {layer.type}
            local out = self.objects[#self.objects]
            out.type = object.type
            out.shape = object.shape
            out.pos = point(object.x, object.y)
            out.properties = object.properties
            -- convert polyline to absolute position
            if object.shape == 'polyline' then
               out.line = {}
               for _,point in ipairs(object.polyline) do
                  out.line[#out.line+1] = point.x + object.x
                  out.line[#out.line+1] = point.y + object.y
               end
            end
         end
      end
   end

   for _,object in ipairs(self.objects) do
      if object.type == 'player' then
         self.player = object
      end
   end
end

function objects:update (input)
   -- TODO: move into player behavior
   local longest_held = math.max(math.max(input.du, input.dd), math.max(input.dl, input.dr))
   local autofire = input.b > 0 and 5 or 15
   local delay = input.b > 0 and 2 or 5
   if longest_held % autofire == delay then
      local p = self.player
      if input.du > 0 then p.pos.y = p.pos.y - 16 end
      if input.dd > 0 then p.pos.y = p.pos.y + 16 end
      if input.dl > 0 then p.pos.x = p.pos.x - 16 end
      if input.dr > 0 then p.pos.x = p.pos.x + 16 end
   end
end

function objects:draw (scroll_pos, view_size)
   for _,object in ipairs(self.objects) do
      if object.shape == 'point' then
         love.graphics.setColor(1, 0, 0)
         love.graphics.circle('line', object.pos.x, object.pos.y, 8)
      elseif object.shape == 'polyline' then
         love.graphics.setColor(0, 0, 1)
         love.graphics.line(object.line)
      end
   end
   love.graphics.setColor(1, 1, 1)
end

return objects
