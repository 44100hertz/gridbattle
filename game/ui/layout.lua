local oop = require 'src/oop'

local layout = oop.class()

-- A 2-column / 4-corner UI. Each element must have these fields:
-- element = {
--    column = 1 (left) or 2 (right),
--    align = 1 (top) or 2 (bottom),
--    size = point(width, height),
-- }
-- function element:draw (point(x, y))
-- end

function layout:init ()
   self.elements = {}
   self.margin = point(10,10)
   self.spacing = 10
end

function layout:add_element (element)
   table.insert(self.elements, element)
end

function layout:draw ()
   local fill_amounts = {{0, 0}, {0, 0}}
   for _,element in ipairs(self.elements) do
      local fill = fill_amounts[element.column][element.align]
      local pos = self.margin + point(0,fill)
      if element.column == 2 then
         pos.x = GAME.size.x - pos.x - element.size.x
      end
      if element.align == 2 then
         pos.y = GAME.size.y - pos.y - element.size.y
      end
      element:draw(pos)
      fill = fill + element.size.y + self.spacing
      fill_amounts[element.column][element.align] = fill
   end
end

return layout
