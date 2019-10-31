local oop = require 'src/oop'
local text = require 'src/text'
local scene = require 'src/scene'

local dialog = {
   transparent = true
}

function dialog.new (_text, x, y, color)
   local self = oop.instance(dialog, {text=_text, x=x, y=y})
   self.color = color or {0,0,0}
   self.border_width = 4
   self.font = 'flavor'
   return self
end

function dialog:update (input_list)
   local input = input_list[1]
   if input.a == 1 or input.b == 1 then
      scene.pop()
   end
end

function dialog:draw ()
   self.w, self.h = text.getsize(self.font, self.text)
   local border = self.border_width

   love.graphics.setColor(unpack(self.color))
   love.graphics.rectangle('fill', self.x-border, self.y-border,
                           self.w+2*border, self.h+2*border)
   love.graphics.setColor(1.0, 1.0, 1.0)
   text.draw(self.font, self.text, self.x, self.y)
end

return dialog
