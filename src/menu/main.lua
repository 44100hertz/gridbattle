local input = require "input"
local fonts = require "fonts"

local directions = {
   du = "u", dd = "d",
   dl = "l", dr = "r",
}

local buttons = {
   "a", "b", "l", "r", "st", "sel"
}

local mod, current, sel
local wait

return {
   start = function (lastmod, newmenu)
      menu = newmenu
      sel = menu[1]
      mod = lastmod
      wait = 1
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
      if menu.draw then menu.draw() end

      for _,v in ipairs(menu) do
         if sel.draw then sel:draw() end
         if v.text then
            love.graphics.setFont(menu.font)
            love.graphics.print(v.text, v.x, v.y)
         end
      end
   end,
}
