local fonts = require "fonts"
local input = require "input"
local main = require "main"

local drawtxt = function (text, x, y)
end

local options
local root = {}
root[1] = {
   x=120, y=80, text="start",
   u = root[3], d = root[2],
   a = function ()
      main.pushstate(require "battle/main", require "battle/sets/test")
   end,
}
root[2] = {
   x=120, y=100, text="options",
   u = root[1], d = root[3],
   a = function () return optionsmenu end,
}
root[3] = {
   x=120, y=120, text="exit",
   u = root[2], d = root[1],
   a = function () love.event.quit() end,
   draw = function () drawtxt("exit", 120, 100) end,
}

-- options = {}
-- options[1] = {
--    draw = function () drawtxt("back", 120, 60) end,
--    choose = function () return 0 end
-- }

local bg = love.graphics.newImage("img/menu.png")
local current, sel

return {
   start = function ()
      current = root
      sel = current[1]
   end,

   update = function ()
      if input.du == 1 and sel.u then
	 sel = sel.u
      elseif input.dd == 1 and sel.d then
         sel = sel.d
      elseif input.dl == 1 and sel.l then
         sel = sel.l
      elseif input.dr == 1 and sel.r then
         sel = sel.r
      elseif input.a == 1 and sel.a then
	 sel.a()
      end
   end,

   draw = function ()
      love.graphics.draw(bg)
      for _,v in ipairs(current) do
         love.graphics.setFont(fonts.std15)
         love.graphics.print(v.text, v.x, v.y)
      end
   end,
}
