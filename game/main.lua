local oop = require 'src/oop'
_G.point = require 'src/point'

local input = require 'src/input'
local scene = require 'src/scene'
local config = require 'src/config'
local menu = require 'src/menu'

local total_time = 0
local frame_count = 0
local next_tick = 0

local framedump_canvas, framedump_dir

function love.load ()
   GAME = {}
   GAME.tickrate = 60
   GAME.size = point(512, 288)
   GAME.tickperiod = 1/GAME.tickrate

   GAME.input = input()
   GAME.scene = scene()

   GAME.chipdb = love.filesystem.load('chipdb.lua')()
   -- Give chips an index field based on their order in the file, and
   -- allow chips to be looked up by name.
   for i,chip in ipairs(GAME.chipdb) do
      chip.index = i
      GAME.chipdb[chip.name] = chip
   end
   GAME.imgdb = love.filesystem.load('imgdb.lua')()

   GAME.config = config()

   love.graphics.setDefaultFilter('nearest', 'nearest')
   love.graphics.setNewFont('fonts/squrave.ttf', 32, 'none')

   if arg[2] == 'dump' then
      framedump_canvas = love.graphics.newCanvas(GAME.size:unpack())
      framedump_dir = '../framedump/' .. os.time()
      love.filesystem.createDirectory(framedump_dir)
   end

   GAME.scene:push(menu('title'))
end

function love.draw ()
   love.graphics.origin()
   love.graphics.scale(GAME.config.settings.game_scale,
                       GAME.config.settings.game_scale)
   GAME.scene:draw()
--   -- Memory usage
--   love.graphics.origin()
--   love.graphics.print(math.floor(collectgarbage('count')))
end

function love.update (dt)
   -- This loop forces the game to run at a fixed speed.
   total_time = total_time + dt
   while total_time > next_tick do
      next_tick = next_tick + GAME.tickperiod
      GAME.scene:update()
      -- Frame dumping; frames are dumped at the actual tick rate.
      frame_count = frame_count + 1
      if framedump_dir then
         love.graphics.origin()
         framedump_canvas:renderTo(oop.bind_by_name(GAME.scene, 'draw'))
         local imgdata = framedump_canvas:newImageData()
         imgdata:encode('tga', framedump_dir .. frame_count .. '.tga')
      end
   end
end
