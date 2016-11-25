local state = require "src/state"
local input = require "src/input"
local test = require "src/test"

gamewidth = 400
gameheight = 240
gamescale = 2

love.run = function ()
   local outdir
   if arg[2] == "dump" then
      outdir = "/out" .. os.time()
      love.filesystem.createDirectory(outdir)
   end

   love.math.setRandomSeed(os.time())
   local time = 0

   love.window.setMode(gamewidth*gamescale, gameheight*gamescale)
   love.graphics.setDefaultFilter("nearest", "nearest")

   local canvas = love.graphics.newCanvas(gamewidth, gameheight)

   state.push(require "res/menu/title")

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
      love.graphics.draw( canvas, 0,0,0, gamescale )
      love.graphics.present()

      if outdir then
         time = time + 1
         local imgdata = canvas:newImageData()
         imgdata:encode("tga", outdir .. "/" .. time .. ".tga")
      end
   end
end
