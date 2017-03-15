local game = require "res/game"
local scene = require "src/scene"
local gamescale = 3

love.run = function ()
   local outdir
   if arg[2] == "dump" then
      outdir = "out/" .. os.time()
      love.filesystem.createDirectory(outdir)
   end

   love.math.setRandomSeed(os.time())
   local time = 0

   love.window.setMode(GAME.width*gamescale, GAME.height*gamescale)
   love.graphics.setDefaultFilter("nearest", "nearest")

   local canvas = love.graphics.newCanvas(GAME.width, GAME.height)
   game.start()

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

      scene.update()

      love.graphics.setBlendMode("alpha", "alphamultiply")
      canvas:renderTo(scene.draw)

--      love.graphics.setBlendMode("replace", "premultiplied")
      love.graphics.draw( canvas, 0,0,0, gamescale )
      love.graphics.print(math.floor(collectgarbage("count")))
      love.graphics.present()

      if outdir then
         time = time + 1
         local imgdata = canvas:newImageData()
         imgdata:encode("tga", outdir .. "/" .. time .. ".tga")
      end
   end
end
