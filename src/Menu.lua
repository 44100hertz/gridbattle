local text = require "src/text"
local lg = love.graphics

local Menu = {}
Menu.__index = Menu

function Menu:new (menu)
   menu = require(PATHS.menu .. menu)
   self = menu
   setmetatable(self, Menu)
   if menu.bg_img then
      self.bg_image =
         lg.newImage(PATHS.menu .. self.bg_img .. ".png")
      self.bg_img = nil
   end
   self.sel = 1
   return self
end

local input_check = {
   "a", "b", "dl", "dr", "l", "r"
}

function Menu:update (input)
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
   if check"dd" then
      self.sel = self.sel % #self + 1
   elseif check"du" then
      self.sel = (self.sel-2) % #self + 1
   end
end

function Menu:draw ()
   if self.bg_image then
      lg.draw(self.bg_image)
   else
      lg.clear(0,0,0)
   end
   for i,v in ipairs(self) do
      local y = self.y + i * self.spacing

      local drawtext = function ()
         text.draw(self.font, v[1], GAME.width/2, y, "center")
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

return Menu
