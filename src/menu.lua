local oop = require 'src/oop'

local lg = love.graphics

local menu = oop.class()

function menu.initial_table(name)
   return dofile(PATHS.menu .. name .. '.lua')
end

-- make a new menu
function menu:init (name, ...)
   local t = dofile(PATHS.menu .. name .. '.lua')
   local mt = getmetatable(self)
   self = setmetatable(t, mt)

   if self.bg_img then
      self.bg_image =
         lg.newImage(PATHS.menu .. self.bg_img .. '.png')
      self.bg_img = nil
   end
   self.sel = 1
end

local input_check = {
   'a', 'b', 'dl', 'dr', 'l', 'r'
}

function menu:update (input)
   local check = function (k)
      return (input[1][k]==1 or input[2][k]==1)
   end
   local entry = self[self.sel]
   for _,button in ipairs(input_check) do
      if check(button) and
         entry[button]
      then
         entry[button](entry)
         return
      end
   end
   if check'dd' then
      self.sel = self.sel % #self + 1
   elseif check'du' then
      self.sel = (self.sel-2) % #self + 1
   end
end

function menu:draw ()
   if self.bg_image then
      lg.draw(self.bg_image)
   else
      lg.clear(0,0,0)
   end
   for i,v in ipairs(self) do
      local y = self.y + i * self.spacing

      local drawtext = function ()
         love.graphics.printf(v.text, 0, y, GAME.width, 'center')
      end

      if self.sel==i then
         lg.setColor(1.0, 100/256.0, 100/256.0)
         drawtext()
         lg.setColor(1.0, 1.0, 1.0)
      else
         drawtext()
      end
   end
end

return menu
