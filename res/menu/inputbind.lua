local menu = require "src/menu"
local anim = require "src/anim"
local input = require "src/input"

local binds = require "res/binds"
local fonts = require "res/fonts"

local btns = love.graphics.newImage("res/menu/buttons.png")

local sheet = {}
do
   local iw, ih = btns:getDimensions()
   sheet.ab = anim.sheet(0,0,32,32,iw,ih,2,1)
   sheet.stsel = anim.sheet(0,88,40,32,iw,ih,2,1)
   sheet.dpad = anim.sheet(0,32,40,24,iw,ih,2,1)
   sheet.lr = anim.sheet(0,56,88,16,iw,ih,1,2)
end

local inputmenu = {
   
}

local drawlist = {
   a={sheet.ab, 230, 75, _,_, 230, 65},
   b={sheet.ab, 190, 100, _,_, 190, 90},
   l={sheet.lr, 80, 30, -1, _, 40, 20},
   r={sheet.lr, 180, 30, _, _, 220, 20},
   st={sheet.stsel, 130, 100, _,_, 155, 125},
   sel={sheet.stsel, 90, 100, _,_, 105, 125},
   dl={sheet.dpad, 35, 105, _, math.pi, 10, 80},
   dr={sheet.dpad, 35, 85, _,_, 65, 95},
   du={sheet.dpad, 25, 95, _, math.pi*3/2, 45, 55},
   dd={sheet.dpad, 45, 95, _, math.pi/2, 25, 120},
}

return {
   start = function ()
      menu.start(inputmenu)
   end,

   update = function ()
      
   end,

   draw = function ()
      love.graphics.setFont(fonts.std15)
      local offx, offy = 70, 60
      love.graphics.clear(43,81,109)
      for k,v in pairs(drawlist) do
	 local index = input[k]>0 and 2 or 1
	 love.graphics.draw(btns, v[1][index], v[2]+offx, v[3]+offy, v[5], v[4], 1)
      end
      for k,v in pairs(drawlist) do
	 love.graphics.printf(
	    input.keyBind[k], v[6]+offx-50, v[7]+offy, 100, "center")
      end
   end,
}
