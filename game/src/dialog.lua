local oop = require 'src/oop'

local dialog = oop.class{
   transparent = true
}

function dialog:set_text (text)
   self.text = text
   local font = love.graphics.getFont()
   self.w = font:getWidth(self.text)
   self.h = font:getHeight(self.text)
end

function dialog:init (text, pos, color)
   self:set_text(text)
   self.pos = pos
   self.color = color or {0,0,0}
   self.border_width = 4
end

function dialog:update ()
   if GAME.input:hit'a' or GAME.input:hit'b' then
      GAME.scene:pop()
   end
end

function dialog:draw ()
   local border = self.border_width
   love.graphics.setColor(unpack(self.color))
   love.graphics.rectangle('fill', self.pos.x-border, self.pos.y-border,
                           self.w+2*border, self.h+2*border)
   love.graphics.setColor(1.0, 1.0, 1.0)
   love.graphics.printf(self.text, self.pos.x, self.pos.y, self.w)
end

return dialog
