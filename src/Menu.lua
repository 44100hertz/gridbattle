local input = require "src/input"
local text = require "src/text"

local Menu = {
   sel = 1,
}
Menu.__index = Menu

function Menu:new (new_menu)
   self = {data=new_menu}
   setmetatable(self, Menu)
   if new_menu.bg_image then
      self.bg_image =
         love.graphics.newImage("res/menu/" .. new_menu.bg_image .. ".png")
   end
   return self
end

function Menu:update ()
   if input.a==1 then
      self.data[self.sel][2]() return end
   if input.dd==1 then
      self.sel = self.sel % #self.data + 1 end
   if input.du==1 then
      self.sel = (self.sel-2) % #self.data + 1 end
end

function Menu:draw ()
   if self.bg_image then love.graphics.draw(self.bg_image) end
   for i,v in ipairs(self.data) do
      local w,h = text.get_size("title", v[1])
      local x = GAME.width / 2 - w / 2
      local y = self.data.y + i * h
      if self.sel==i then
         love.graphics.setColor(255, 100, 100)
         text.draw(self.data.font, v[1], x, y)
         love.graphics.setColor(255, 255, 255)
      else
         text.draw(self.data.font, v[1], x, y)
      end
   end
end

return Menu
