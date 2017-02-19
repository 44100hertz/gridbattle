local menu = require "src/menu"
local anim = require "src/anim"
local input = require "src/input"
local state = require "src/state"

local binds = require "res/binds"
local fonts = require "res/fonts"
local btns = love.graphics.newImage("res/menu/buttons.png")

local bindindex = "friendly"

local sheet = {}
do
   local iw, ih = btns:getDimensions()
   sheet.ab = anim.sheet(0,0,32,32,iw,ih,2,1)
   sheet.stsel = anim.sheet(0,88,40,32,iw,ih,2,1)
   sheet.dpad = anim.sheet(0,32,40,24,iw,ih,2,1)
   sheet.lr = anim.sheet(0,56,88,16,iw,ih,1,2)
end

local inputmenu = {
   font = fonts.std15,
   b = state.pop,
   [1] = {
      x=50, y=50, text="back",
      dr=2, dl=2,
      a = state.pop,
   },
   [2] = {
      x=100, y=50, text="apply",
      dr=1, dl=1,
--      a = function () input.rebind(binds[bindindex]) end,
   }
}

local drawlist = {
   a={sheet.ab, 230, 75, _,_, 230, 65},
   b={sheet.ab, 190, 100, _,_, 190, 90},
   l={sheet.lr, 80, 30, -1, _, 40, 20},
   r={sheet.lr, 180, 30, _, _, 220, 20},
   st={sheet.stsel, 130, 100, _,_, 145, 122},
   sel={sheet.stsel, 90, 100, _,_, 115, 85},
   dl={sheet.dpad, 35, 105, _, math.pi, 10, 80},
   dr={sheet.dpad, 35, 85, _,_, 65, 95},
   du={sheet.dpad, 25, 95, _, math.pi*3/2, 45, 55},
   dd={sheet.dpad, 45, 95, _, math.pi/2, 25, 120},
}

local offx, offy = 70, 60
return {
   start = function ()
      menu.start(inputmenu)
   end,

   update = function ()
      menu.update(inputmenu)
   end,

   draw = function ()
      love.graphics.setFont(fonts.std15)
      love.graphics.clear(43,81,109)
      menu.textdraw(inputmenu)
      for k,v in pairs(drawlist) do
	 local index = input[k]>0 and 2 or 1
	 love.graphics.draw(
	    btns, v[1][index],
	    v[2]+offx, v[3]+offy,
	    v[5], v[4], 1)
      end
      for k,v in pairs(drawlist) do
	 love.graphics.printf(
	    "profile: " .. bindindex .. " (l/r)", 100, 210,
	    200, "center")
	 love.graphics.printf(
	    binds[bindindex][k], v[6]+offx-50, v[7]+offy,
	    100, "center")
      end
   end,
}
