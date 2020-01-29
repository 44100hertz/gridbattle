local oop = require 'src/oop'

local lg = love.graphics

local menu = oop.class()

-- make a new menu
function menu.manual_init (name, ...)
   local self = love.filesystem.load('menus/' .. name .. '.lua')()
   if self.init then
      self:init(...)
   end
   setmetatable(self, {__index = menu})
   if self.bg_img then
      self.bg_image =
         lg.newImage('menus/' .. self.bg_img .. '.png')
      self.bg_img = nil
   end
   self.sel = 1
   return self
end

function menu:update ()
   local entry = self[self.sel]
   for _,button in ipairs(GAME.input.keys) do
      if GAME.input:hit(button) and entry[button] then
         entry[button](entry)
         return
      end
   end
   if GAME.input:hit'dd' then
      self.sel = self.sel % #self + 1
   elseif GAME.input:hit'du' then
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
         love.graphics.printf(v.text, 0, y, GAME.size.x, 'center')
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
