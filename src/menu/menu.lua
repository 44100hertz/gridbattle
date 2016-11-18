local rootmenu = {
   {text = "start demo",
    func = function ()
       main.loadstate(require "battle/battle")
    end
   },
   {text = "exit",
    func = function ()
       love.event.quit()
    end
   },
}

local bg = love.graphics.newImage("img/menu.png")

local currentmenu
local sel = 1

return {
   init = function ()
      current = rootmenu
   end,

   update = function ()
      if input.dd == 1 then
	 if sel < #current then sel = sel + 1 end
      end

      if input.du == 1 then
	 if sel > 1 then sel = sel - 1 end
      end

      if input.a == 1 then
	 current[sel].func()
      end
   end,

   draw = function ()
      love.graphics.draw(bg)
      for k,v in ipairs(current) do
	 love.graphics.circle("fill", 70, 80+sel*20, 5, 5)
	 love.graphics.print(v.text, 80, 80+k*20)
      end
   end,
}
