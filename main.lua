require "lib"

local SDL = require "SDL"
local image = require "SDL.image"

local scene = require "src/scene"
local config = require "src/config"
local input = require "src/input"

_G.RES_PATH = arg[2] or "res/"
local game = require(RES_PATH .. "game")

config.load()

local ret, err = SDL.init{SDL.flags.video}
if not ret then error(err) end

local formats, ret, err = image.init{image.flags.PNG}
if not ret then error(err) end

local win, err = SDL.createWindow {
   title = "Gridbattle",
   width = GAME.width * config.c.gamescale,
   height = GAME.height * config.c.gamescale,
}
if not win then error(err) end

local rdr, err = SDL.createRenderer(win, 0, {presentVSYNC = true})
if not rdr then error(err) end
rdr:setLogicalSize(GAME.width, GAME.height)
_G.RDR = rdr

local outdir

do
   _G.PATHS = {}
   local paths = {
      chipdb = "chipdb",
      enemydb = "enemydb",
      chips = "chips/",
      bg = "bg/",
      fonts = "fonts/",
      foldedit = "foldedit/",
      folders = "folders/",
      menu = "menu/",
      battle = "battle/",
      sets = "battle/sets/",
   }

   for k,v in pairs(paths) do
      _G.PATHS[k] = RES_PATH .. v
   end

   -- Index chips by name or by index interchangeably
   local chipdb = require(PATHS.chipdb)
   for i,v in ipairs(chipdb) do
      v.index = i
      chipdb[v[1]] = v
   end
end

-- if arg[3] == "dump" then
--    outdir = "out/" .. os.time()
--    love.filesystem.createDirectory(outdir)
-- end

-- love.math.setRandomSeed(os.time())

local time = 0
--lg.setDefaultFilter("nearest", "nearest")
--local canvas = lg.newCanvas(GAME.width, GAME.height)
GAME.tickperiod = (1/GAME.tickrate)

game.start()

--local next_tick = lt.getTime() + GAME.tickperiod

local drawthread = function ()
   --lg.setBlendMode("alpha", "alphamultiply")
--   canvas:renderTo(scene.draw)

   --lg.setBlendMode("replace", "premultiplied")
--   lg.draw(canvas, 0,0,0, config.c.gamescale)
--   lg.print(math.floor(collectgarbage("count")))
--   lg.present()

   -- if outdir then
   --    time = time + 1
   --    local imgdata = canvas:newImageData()
   --    imgdata:encode("tga", outdir .. "/" .. time .. ".tga")
   -- end
end

while true do
   for e in SDL.pollEvent() do
      if e.type == SDL.event.Quit then
         return
      elseif e.type == SDL.event.KeyDown then
         input.handle_keydown(e)
      elseif e.type == SDL.event.KeyUp then
         input.handle_keyup(e)
      end
   end
   scene.update()
   scene.draw()
   rdr:present()
   -- while(lt.getTime() < next_tick) do
   --    love.draw(lt.getTime())
   -- end
   -- next_tick = next_tick + GAME.tickperiod
end
