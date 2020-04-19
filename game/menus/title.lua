local menu = require 'ui/menu'

local world = require 'world/world'

local battle = require 'battle/battle'
local foldedit = require 'foldedit/editor'

local title = {
   y = 40,
   spacing = 16,
   font = 'title',
   bg_img = 'title',
   {
      text = 'worldmap test',
      a = function ()
         GAME.scene:push_fade({}, world('test0'))
      end,
   },
   {
      text = 'battle',
      a = function ()
         GAME.scene:push_fade({}, battle('test'))
      end,
   },
   {
      text = 'folder editor',
      a = function ()
         GAME.scene:push_fade({}, foldedit('test-collection', 'test'))
      end,
   },
   {
      text = 'config',
      a = function ()
         GAME.scene:push_fade({}, menu('settings'))
      end,
   },
   {
      text = 'exit',
      a = love.event.quit
   },
}

return title
