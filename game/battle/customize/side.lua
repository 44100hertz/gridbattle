local lg = love.graphics

local oop = require 'src/oop'
local dialog = require 'src/dialog'
local image = require 'src/image'

local side = oop.class()

function side:init(battle, side_index)
   self.battle = battle
   self.input_index = side_index
   local side_data = {
      {0},
      {120},
   }
   self.offset = unpack(side_data[side_index])
   local deck = battle.folders[side_index]
   self.pal = deck:draw(5, self.pal)
   self.queue = battle.state.sides[side_index][1].queue
   self.sel = 1
   self.image = image('customize')
end

function side:update(input_list)
   if self.ready then
      return
   end

   -- A valid queue must either be all the same letter, or the same chip,
   -- besides letter.
   local queue_is_valid = function (queue)
      local diff_letter, diff_chip
      for i=2,#queue do
         if queue[i].name ~= queue[1].name then diff_chip = true end
         if queue[i].ltr ~= queue[1].ltr then diff_letter = true end
      end
      return not (diff_letter and diff_chip)
   end

   local input = input_list[self.input_index]
   local sel = self.pal[self.sel]

   if     input.dl==1 then self.sel = (self.sel-1)%6
   elseif input.dr==1 then self.sel = (self.sel+1)%6
   elseif input.a==1 and self.sel==0 then
      self.ready = true
   elseif input.a==1 and sel then
      table.insert(self.queue, sel)
      if queue_is_valid(self.queue) then
         self.pal[self.sel] = nil
      else
         table.remove(self.queue)
      end
   elseif input.b==1 and #self.queue > 0 then
      local i=1
      while(self.pal[i]~=nil) do i=i+1 end
      self.pal[i] = table.remove(self.queue)
--   elseif input.l==1 and not self.two_player and sel then
   elseif input.l==1 and sel then
      local chip = GAME.chipdb[sel.name]
      GAME.scene:push(dialog(chip.desc, 132, 16))
   elseif input.sel==1 then
      self.hide = not self.hide
   end
end

function side:draw()
   if self.hide then
      return
   end
   lg.push()
   lg.translate(self.offset, 0)

   self.image:set_sheet 'bg'
   self.image:draw(0,0)

   -- Palette --
   for i=1,10 do
      local x = 8 + 16*(i-1%5)
      local y = i<=5 and 104 or 128
      if self.pal[i] then
         self.battle.chip_artist:draw_icon(self.pal[i].name, point(x,y))
         local letter = self.pal[i].ltr:byte() - ('a'):byte() + 1
         self.image:set_sheet'letter'
         self.image:draw(x, y+16, nil, letter)
      end
      if self.sel==i then
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
   local button_sel = 1
   if self.sel==0 then button_sel = 2 end
   if self.ready then button_sel = 3 end
   self.image:set_sheet'button'
   self.image:draw(96, 112, nil, button_sel)

   -- Art --
   local sel = self.pal[self.sel]
   if sel then
      self.battle.chip_artist:draw_art(sel.name, point(8, 16))
      local damage = GAME.chipdb[sel.name].damage
      love.graphics.print(tostring(damage), 8, 88)
   end

   lg.pop()
end

return side
