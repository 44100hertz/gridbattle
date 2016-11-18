local rootmenu, optionsmenu

local currentmenu, sel

rootmenu = {
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
   {text = "options",
    func = function ()
       current = optionsmenu
       sel = 1
    end
   },
}

optionsmenu = {
   {text = "back",
    func = function ()
       current = rootmenu
    end
   }
}

local bg = love.graphics.newImage("img/menu.png")

local framecounter
return {
   init = function ()
      love.graphics.setFont(fonts.std15)
      sel = 1
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
      counter = counter + 1
      local size = (counter/3 % 5) + 1
      for k,v in ipairs(current) do
	 love.graphics.circle("fill", 70, 67+sel*20, size)
	 love.graphics.print(v.text, 80, 60+k*20)
      end
   end,
}
