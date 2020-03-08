local image = require 'src/image'
local oop = require 'src/oop'

local dialog = require 'ui/dialog'

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
   self.dialog = dialog('', point(132, 16))
end

function customize:update ()
   -- A valid queue is either:
   --   All same letter
   --   All same chip
   local queue_is_valid = function (queue)
      local same_letter, same_chip = true, true
      for i=2,#queue do
         if queue[i].name ~= queue[1].name then
            same_chip = false
         end
         if queue[i].letter ~= queue[1].letter then
            same_letter = false
         end
      end
      return same_letter or same_chip
   end

   local chip = self.palette[self.selection]
   if GAME.input:hit'dl' then
      self.selection = (self.selection-1)%6
   elseif GAME.input:hit'dr' then
      self.selection = (self.selection+1)%6
   elseif GAME.input:hit'a' and self.selection == 0 then
      -- Hit GO button, exit scene
      GAME.scene:pop()
      GAME.scene:push(go_screen())
   elseif GAME.input:hit'a' and chip then
      -- Try putting in queue
      table.insert(self.queue, chip)
      if queue_is_valid(self.queue) then
         self.palette[self.selection] = nil
      else
         table.remove(self.queue)
      end
   elseif GAME.input:hit'b' and #self.queue > 0 then
      local i=1
      while(self.palette[i]~=nil) do i=i+1 end
      self.palette[i] = table.remove(self.queue)
   elseif GAME.input:hit'l' and chip then
      self.show_dialog = not self.show_dialog
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
         local letter = self.palette[i].letter:byte() - ('a'):byte() + 1
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
   local go_button_graphic = 1
   local chip = self.palette[self.selection]
   if self.selection == 0 then
      self.dialog:set_text('Enter the battle!')
      go_button_graphic = 2
   elseif chip then
      local db_info = GAME.chipdb[chip.name]
      self.dialog:set_text(db_info.info)
      self.battle.chip_artist:draw_art(chip.name, point(8, 16))
      local damage = db_info.damage
      love.graphics.print(tostring(damage), 8, 88)
   else
      self.dialog:set_text('-No Chip-')
   end
   self.image:set_sheet'button'
   self.image:draw(96, 112, nil, go_button_graphic)

   self.dialog:draw()

   love.graphics.pop()
end

return customize
