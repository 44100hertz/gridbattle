local input = require "src/input"

local directions = {
   du = "u", dd = "d",
   dl = "l", dr = "r",
}

local buttons = {
   "a", "b", "l", "r", "st", "sel"
}

local sel, wait

return {
   start = function (menu)
      menu.sel = 1
      wait = 1
   end,

   update = function (menu)
      local isdirpressed = false
      for k,v in pairs(directions) do
         if input[k] > 0 then isdirpressed = true end
         if input[k] == wait and menu[menu.sel][v] then
            wait = wait==1 and 20 or wait+8
            menu.sel = menu[menu.sel][v]
            break
         end
      end
      if not isdirpressed then
         wait = 1
      end

      for _,v in ipairs(buttons) do
         if input[v]==1 then
            if menu[menu.sel][v] then
               menu[menu.sel][v]()
               break
            elseif menu[v] then
               menu[v]()
               break
            end
         end
      end
   end,

   textdraw = function (menu)
      for k,v in ipairs(menu) do
         love.graphics.setFont(menu.font)
	 if k==menu.sel then love.graphics.setColor(255,0,0,255) end
         love.graphics.print(v.text, v.x, v.y)
	 if k==menu.sel then love.graphics.setColor(255,255,255,255) end
      end
   end,

   gfxdraw = function (menu)
   end,
}
