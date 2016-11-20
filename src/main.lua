local input = require "input"
local test = require "test"

local state
local statestack = {}

local main = {
   loadstate = function (mod)
      state = mod
      state.start()
   end,

   pushstate = function (mod, ...)
      table.insert(statestack, state)
      mod.start(state, ...)
      mod.update()
      state = mod
   end,

   popstate = function ()
      if #statestack > 0 then
	 state = table.remove(statestack)
	 return true
      end
   end,
}

local gamewidth = 400
local gameheight = 240
local screenscale = 3

love.run = function ()
   if arg[2] == "dump" then screenscale = 1 end
   local framecounter = 0
   love.window.setMode(gamewidth*screenscale, gameheight*screenscale)
   love.graphics.setDefaultFilter("nearest", "nearest")

   local canvas = love.graphics.newCanvas(gamewidth, gameheight)

   love.math.setRandomSeed(os.time())
   main.loadstate(require "menu/title")

   while true do
      love.event.pump()
      for name, a,b,c,d,e,f in love.event.poll() do
	 if name == "quit" then
	    if not love.quit or not love.quit() then
	       return a
	    end
	 end
	 love.handlers[name](a,b,c,d,e,f)
      end

      input.update()
      state.update()

      love.graphics.setBlendMode("alpha", "alphamultiply")
      canvas:renderTo( function()
	    state.draw()
      end)

      love.graphics.setBlendMode("replace", "premultiplied")
      love.graphics.draw( canvas, 0,0,0, screenscale )
      love.graphics.present()

      if arg[2] == "dump" then
	 framecounter = framecounter + 1
	 local screenshot = love.graphics.newScreenshot()
	 local name = string.format("%3.3d.tga", framecounter)
	 screenshot:encode("tga", name)
      end
   end
end

love.quit = function ()
   if arg[2] == "dump" then
      os.execute("ffmpeg -framerate 60 -i ~/.local/share/love/src/%03d.tga -vf scale=iw*4:ih*4:sws_flags=neighbor out.mp4")
   end
end

return main
