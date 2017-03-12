local text = require "src/text"

local Menu = {}
Menu.__index = Menu

function Menu:new (new_menu)
   self = new_menu
   setmetatable(self, Menu)
   if new_menu.bg_img then
      self.bg_image =
         love.graphics.newImage("res/menu/" .. self.bg_img .. ".png")
      self.bg_img = nil
   end
   self.sel = 1
   return self
end

function Menu:update (input)
   if input.a==1 then
      self[self.sel][2]() return end
   if input.dd==1 then
      self.sel = self.sel % #self + 1 end
   if input.du==1 then
      self.sel = (self.sel-2) % #self + 1 end
end

function Menu:draw ()
   if self.bg_image then love.graphics.draw(self.bg_image) end
   for i,v in ipairs(self) do
      local y = self.y + i * self.spacing

      local drawtext = function ()
         text.draw(self.font, v[1], GAME.width/2, y, "center")
      end

      if self.sel==i then
         love.graphics.setColor(255, 100, 100)
         drawtext()
         love.graphics.setColor(255, 255, 255)
      else
         drawtext()
      end
   end
end

return Menu
