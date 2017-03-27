local lg = love.graphics

local scene = require "src/scene"
local dialog = require "src/dialog"
local text = require "src/text"
local chip_artist = require "battle/chip_artist"
local chipdb = require(PATHS.chipdb)

local img = lg.newImage(PATHS.battle .. "chips.png")
local sheet = (require "src/quads").multi_sheet{
   img = img,
   bg = {0,0,120,160},
   chipbg = {0,160,16,16,6},
   letter = {0,176,16,8,5},
   button = {0,184,16,16,3},}

local set, two_player

local Side = {}
Side.__index = Side
function Side:start(sidestr, deck)
   if not self.enable then return end
   self.deck = deck
   self.queue = set[sidestr].queue
   for i,_ in ipairs(self.queue) do self.queue[i] = nil end
   self.pal = deck:draw(5, self.pal)
   self.sel = 1
   self.ready = false
end

local check_queue_valid = function (queue)
   local diff_letter, diff_chip
   for i=2,#queue do
      diff_letter = queue[i].name ~= queue[1].name
      diff_chip = queue[i].ltr ~= queue[1].ltr
   end
   return not (diff_letter and diff_chip)
end
function Side:update(input_list)
   if not self.enable or self.ready then return end
   local input = input_list[self.input_index]
   local sel = self.pal[self.sel]

   if     input.dl==1 then self.sel = (self.sel-1)%6
   elseif input.dr==1 then self.sel = (self.sel+1)%6
   elseif input.a==1 and self.sel==0 then
      self.ready = true
   elseif input.a==1 and sel then
      table.insert(self.queue, sel) -- Try adding to queue
      if check_queue_valid(self.queue) then
         self.pal[self.sel] = nil -- Complete transaction
      else
         table.remove(self.queue) -- Put it back
      end
   elseif input.b==1 and #self.queue > 0 then
      local i=1
      while(self.pal[i]~=nil) do i=i+1 end
      self.pal[i] = table.remove(self.queue)
   elseif input.sel==1 and not two_player then
      local chip = chipdb[sel.name]
      scene.push(dialog.popup, chip.desc, 132, 16)
   end
end
function Side:draw()
   if not self.enable then return end
   lg.draw(img, sheet.bg, self.offset)

   -- Palette --
   for i=1,10 do
      local x = self.offset + 8 + 16*(i-1%5)
      local y = i<=5 and 104 or 128
      if self.pal[i] then
         chip_artist.draw_icon(self.pal[i].name, x, y)
         local letter = self.pal[i].ltr:byte() - ("a"):byte() + 1
         lg.draw(img, sheet.letter[letter], x, y+16)
      end
      if self.sel==i then
         lg.draw(img, sheet.chipbg[1], x, y)
      end
   end

   -- Queue --
   for i=1,5 do
      local x = 96 + self.offset
      local y = 24 + 16*(i-1)
      if self.queue[i] then
         chip_artist.draw_icon(self.queue[i].name, x, y)
      end
   end

   -- GO button --
   local button_sel = 1
   if self.sel==0 then button_sel = 2 end
   if self.ready then button_sel = 3 end
   lg.draw(img, sheet.button[button_sel], 96 + self.offset, 112)

   -- Art --
   local sel = self.pal[self.sel]
   if sel then
      chip_artist.draw_art(sel.name, 8 + self.offset, 16, 1)
      local damage = chipdb[sel.name].damage
      text.draw("flavor", tostring(damage), 8, 88)
   end
end

local left = {
   input_index = 1,
   offset = 0,
}
setmetatable(left, Side)
local right = {
   input_index = 2,
   offset = 120,
}
setmetatable(right, Side)

return {
   transparent = true,
   queue = queue,
   start = function (new_set, left_deck, right_deck)
      set = new_set
      left.enable = left_deck.data and true
      right.enable = right_deck.data and true
      two_player = (left.enable and right.enable)
      left:start("left", left_deck)
      right:start("right", right_deck)
   end,

   update = function (_, input)
      left:update(input)
      right:update(input)
      if (not left.enable or left.ready) and
         (not right.enable or right.ready)
      then
         scene.pop()
         scene.push(require(PATHS.battle .. "go_screen"))
      end
   end,

   draw = function ()
      left:draw()
      right:draw()
   end,
}
