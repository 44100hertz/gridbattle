local image = require 'src/image'
local oop = require 'src/oop'

local go_screen = require 'battle/go_screen'

local customize = oop.class {
   transparent = true,
}

function customize:init (battle, folder, queue)
   self.battle = battle
   self.queue = queue
   self.folder = folder
   self.palette = folder:draw(5, self.palette)
   self.selection = 1
   self.image = image('customize')
   self.offset = point(10,10)
end

function customize:update ()
   -- A valid queue is either:
   --   All same letter
   --   All same chip
   local queue_is_valid = function (queue)
      for i=2,#queue do
         if queue[i].name ~= queue[1].name then
            return false
         end
         if queue[i].letter ~= queue[1].letter then
            return false
         end
      end
      return true
   end

   local selection = self.palette[self.selection]
   if GAME.input:hit'dl' then
      self.selection = (self.selection-1)%6
   elseif GAME.input:hit'dr' then
      self.selection = (self.selection+1)%6
   elseif GAME.input:hit'a' and self.selection == 0 then
      -- Hit GO button, exit scene
      GAME.scene:pop()
      GAME.scene:push(go_screen())
   elseif GAME.input:hit'a' and selection then
      -- Try putting in queue
      table.insert(self.queue, selection)
      if queue_is_valid(self.queue) then
         self.palette[self.selection] = nil
      else
         table.remove(self.queue)
      end
   elseif GAME.input:hit'b' and #self.queue > 0 then
      local i=1
      while(self.palette[i]~=nil) do i=i+1 end
      self.palette[i] = table.remove(self.queue)
--   elseif GAME.input:hit'l' and selection then
--      local chip = GAME.chipdb[selection.name]
--      GAME.scene:push(dialog(chip.desc, 132, 16))
   elseif GAME.input:hit'option' then
      self.hide = not self.hide
   elseif GAME.debug.instant_reload_palette and GAME.input:hit'r' then
      self.palette = self.folder:draw(5)
   end
end

function customize:draw ()
   love.graphics.push()
   love.graphics.translate(self.offset:unpack())

   self.image:set_sheet 'bg'
   self.image:draw(0,0)

   -- Palette --
   for i=1,10 do
      local x = 8 + 16*(i-1%5)
      local y = i<=5 and 104 or 128
      if self.palette[i] then
         self.battle.chip_artist:draw_icon(self.palette[i].name, point(x,y))
         local letter = self.palette[i].ltr:byte() - ('a'):byte() + 1
         self.image:set_sheet'letter'
         self.image:draw(x, y+16, nil, letter)
      end
      if self.selection == i then
         self.image:set_sheet'chipbg'
         self.image:draw(x, y)
      end
   end

   -- Queue --
   for i=1,5 do
      if self.queue[i] then
         local pos = point(96, 24 + 16*(i-1))
         self.battle.chip_artist:draw_icon(self.queue[i].name, pos)
      end
   end

   -- GO button --
   local button_selection = 1
   if self.selection == 0 then button_selection = 2 end
   if self.ready then button_selection = 3 end
   self.image:set_sheet'button'
   self.image:draw(96, 112, nil, button_selection)

   -- Art --
   local selection = self.palette[self.selection]
   if selection then
      self.battle.chip_artist:draw_art(selection.name, point(8, 16))
      local damage = GAME.chipdb[selection.name].damage
      love.graphics.print(tostring(damage), 8, 88)
   end

   love.graphics.pop()
end

return customize
