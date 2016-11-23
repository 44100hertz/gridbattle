local input = require "input"
local fonts = require "fonts"

local mod, current, sel
local bg
local wait, reprate

local directions = {
   du = "u", dd = "d",
   dl = "l", dr = "r",
}

local buttons = {
   "a", "b", "l", "r", "start", "sel"
}

return {
   start = function (lastmod, newmenu, newbg)
      menu = newmenu
      sel = menu[1]
      mod = lastmod
      bg = newbg
      wait = 1
      reprate = 20
   end,

   update = function ()
      local isdirpressed = false
      for k,v in pairs(directions) do
         if input[k] > 0 then isdirpressed = true end
         if input[k] == wait and sel[v] then
            wait = wait==1 and 20 or wait+8
            sel = menu[sel[v]]
            break
         end
      end
      if not isdirpressed then
         wait = 1
      end

      for _,v in ipairs(buttons) do
         if input[v]==1 then
            if sel[v] then
               sel[v]()
               break
            elseif menu[v] then
               menu[v]()
               break
            end
         end
      end
   end,

   draw = function ()
      if mod then mod.draw() end
      if bg then love.graphics.draw(bg) end
      love.graphics.circle("fill", sel.x-20, sel.y, 8)
      for _,v in ipairs(menu) do
         love.graphics.setFont(fonts.std15)
         love.graphics.print(v.text, v.x, v.y)
      end
   end,
}
