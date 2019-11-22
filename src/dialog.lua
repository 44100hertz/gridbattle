local oop = require 'src/oop'
local scene = require 'src/scene'

local dialog = oop.class{
   transparent = true
}

function dialog:init (text, x, y, color)
   self.text = text
   self.x = x
   self.y = y
   self.color = color or {0,0,0}
   self.border_width = 4
end

function dialog:update (input_list)
   local input = input_list[1]
   if input.a == 1 or input.b == 1 then
      scene.pop()
   end
end

function dialog:draw ()
   local font = love.graphics.getFont()
   self.w = font.getWidth(self.text)
   self.h = font.getHeight(self.text)
   local border = self.border_width

   love.graphics.setColor(unpack(self.color))
   love.graphics.rectangle('fill', self.x-border, self.y-border,
                           self.w+2*border, self.h+2*border)
   love.graphics.setColor(1.0, 1.0, 1.0)
   love.graphics.printf(self.text, self.x, self.y)
end

return dialog
