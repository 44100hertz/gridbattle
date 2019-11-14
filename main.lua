local scene = require 'src/scene'
local config = require 'src/config'
local menu = require 'src/menu'

local total_time = 0
local frame_count = 0
local next_tick = 0

local framedump_canvas, framedump_dir

function love.load ()
   PATHS = {
      imgdb      = 'res/imgdb',
      chipdb     = 'res/chipdb',
      savedata   = 'res/savedata',
      chips      = 'res/chips/',
      folders    = 'res/folders/',
      bg         = 'res/bg/',
      fonts      = 'res/fonts/',
      menu       = 'res/menu/',

      foldedit   = 'foldedit/',
      battle     = 'battle/',
      sets       = 'battle/sets/',
   }
   GAME = {
      width = 240,
      height = 160,
      tickrate = 60,
   }
   GAME.tickperiod = 1/GAME.tickrate

   GAME.chipdb = dofile(PATHS.chipdb .. '.lua')
   -- Give chips an index field based on their order in the file, and
   -- allow chips to be looked up by name.
   for i,chip in ipairs(GAME.chipdb) do
      chip.index = i
      GAME.chipdb[chip.name] = chip
   end

   config.load()

   love.graphics.setDefaultFilter('nearest', 'nearest')

   if arg[3] == 'dump' then
      framedump_canvas = love.graphics.newCanvas(GAME.width, GAME.height)
      framedump_dir = 'out/' .. os.time()
      love.filesystem.createDirectory(framedump_dir)
   end

   scene.push(menu.new('title'))
end

function love.draw ()
   love.graphics.origin()
   love.graphics.scale( config.c.gamescale, config.c.gamescale )
   scene.draw()
--   -- Memory usage
--   love.graphics.origin()
--   love.graphics.print(math.floor(collectgarbage('count')))
   love.graphics.present()
end

function love.update (dt)
   -- This loop forces the game to run at a fixed speed.
   total_time = total_time + dt
   while total_time > next_tick do
      next_tick = next_tick + GAME.tickperiod
      scene.update()
      -- Frame dumping; frames are dumped at the actual tick rate.
      frame_count = frame_count + 1
      if framedump_dir then
         framedump_canvas:renderTo(scene.draw)
         local imgdata = framedump_canvas:newImageData()
         imgdata:encode('tga', framedump_dir .. '/' .. frame_count .. '.tga')
      end
   end
end
