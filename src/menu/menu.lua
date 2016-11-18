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
local framecounter

return {
   init = function ()
      love.graphics.setFont(fonts.std15)
      current = rootmenu
      counter = 0
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
	 counter = counter + 1
	 local size = (counter/10 % 5) + 1
	 love.graphics.circle("fill", 70, 87+sel*20, size)
	 love.graphics.print(v.text, 80, 80+k*20)
      end
   end,
}
