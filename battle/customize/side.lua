local lg = love.graphics

local oop = require 'src/oop'
local text = require 'src/text'
local scene = require 'src/scene'
local dialog = require 'src/dialog'

local img = (require'src/image').new'customize'
local chipdb = require(PATHS.chipdb)

local side = {}

function side.new(battle, side_index)
   local self = oop.instance(side, {})
   self.battle = battle
   self.input_index = side_index
   local side_data = {
      {0},
      {120},
   }
   self.offset = unpack(side_data[side_index])
   local deck = battle.folders[side_index]
   if not deck.data then
      return nil
   end
   self.queue = battle.state.sides[side_index][1].queue
   self.pal = deck:draw(5, self.pal)
   self.sel = 1
   return self
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
      local chip = chipdb[sel.name]
      scene.push(dialog.popup, chip.desc, 132, 16)
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

   img:set_sheet 'bg'
   img:draw(0,0)

   -- Palette --
   for i=1,10 do
      local x = 8 + 16*(i-1%5)
      local y = i<=5 and 104 or 128
      if self.pal[i] then
         self.battle.chip_artist:draw_icon(self.pal[i].name, x, y)
         local letter = self.pal[i].ltr:byte() - ('a'):byte() + 1
         img:set_sheet'letter'
         img:draw(x, y+16, nil, letter)
      end
      if self.sel==i then
         img:set_sheet'chipbg'
         img:draw(x, y)
      end
   end

   -- Queue --
   for i=1,5 do
      local x = 96
      local y = 24 + 16*(i-1)
      if self.queue[i] then
         self.battle.chip_artist:draw_icon(self.queue[i].name, x, y)
      end
   end

   -- GO button --
   local button_sel = 1
   if self.sel==0 then button_sel = 2 end
   if self.ready then button_sel = 3 end
   img:set_sheet'button'
   img:draw(96, 112, nil, button_sel)

   -- Art --
   local sel = self.pal[self.sel]
   if sel then
      self.battle.chip_artist:draw_art(sel.name, 8, 16, 1)
      local damage = chipdb[sel.name].damage
      text.draw('flavor', tostring(damage), 8, 88)
   end

   lg.pop()
end

return side
