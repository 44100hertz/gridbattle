local text = require "src/text"
local resources = require "src/resources"
local rdr = _G.RDR

local Menu = {}
Menu.__index = Menu
Menu.__gc = function () resources.cleartag(self.uid) end

function Menu:new (menu)
   menu = require(PATHS.menu .. menu)
   self = menu
   self.uid = math.random()
   setmetatable(self, Menu)
   if self.bg_img then
      self.bg_image = resources.getimage(
         PATHS.menu .. self.bg_img .. ".png", self.uid)
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
      rdr:copy(self.bg_image)
   else
      rdr:clear()
   end
   for i,v in ipairs(self) do
      local y = self.y + i * self.spacing

      local drawtext = function (color)
         text.draw(self.font, v[1], GAME.width/2, y, "center", color)
      end

      if self.sel==i then
         drawtext(0xFF5050)
      else
         drawtext()
      end
   end
end

return Menu
