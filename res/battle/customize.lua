local rdr = _G.RDR

local scene = require "src/scene"
local dialog = require "src/dialog"
local text = require "src/text"
local resources = require "src/resources"
local chip_artist = require "battle/chip_artist"
local set = require "battle/set"
local chipdb = require(PATHS.chipdb)

local two_player

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
      if queue[i].name ~= queue[1].name then diff_chip = true end
      if queue[i].ltr ~= queue[1].ltr then diff_letter = true end
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
   elseif input.l==1 and not two_player and sel then
      local chip = chipdb[sel.name]
      scene.push(dialog.popup, chip.desc, 132, 16)
   elseif input.sel==1 then
      self.hide = not self.hide
   end
end
function Side:draw()
   local img = resources.getimage(PATHS.battle .. "chips.png", "battle")
   if not self.enable or self.hide then return end
   rdr:setViewport{x=self.offset, y=0, w=GAME.width, h=GAME.width}
   rdr:copy(img, {x=0, y=0, w=120, h=160}, {x=0, y=0, w=120, h=160})

   -- Palette --
   for i=1,10 do
      local x = 8 + 16*(i-1%5)
      local y = i<=5 and 104 or 128
      if self.pal[i] then
         chip_artist.draw_icon(self.pal[i].name, x, y)
         local letter = self.pal[i].ltr:byte() - ("a"):byte()
         rdr:copy(img, {x=letter*16, y=176, w=16, h=8}, {x=x, y=y+16, w=16, h=8})
      end
      if self.sel==i then
         rdr:copy(img, {x=0, y=160, w=16, h=16}, {x=x, y=y, w=16, h=16})
      end
   end

   -- Queue --
   for i=1,5 do
      local x = 96
      local y = 24 + 16*(i-1)
      if self.queue[i] then
         chip_artist.draw_icon(self.queue[i].name, x, y)
      end
   end

   -- GO button --
   local button_sel = 0
   if self.sel==0 then button_sel = 1 end
   if self.ready then button_sel = 2 end
   rdr:copy(img, {x=button_sel*16, y=184, w=16, h=16}, {x=96, y=112, w=16, h=16})

   -- Art --
   local sel = self.pal[self.sel]
   if sel then
      chip_artist.draw_art(sel.name, 8, 16, 1)
      local damage = chipdb[sel.name].damage
      text.draw("flavor", tostring(damage), 8, 88)
   end

   rdr:setViewport{x=0, y=0, w=GAME.width, h=GAME.height}
end

local left,  right
local clear = function ()
   left = {
      input_index = 1,
      offset = 0,
      deck = nil, queue = nil, pal = nil,
   }
   setmetatable(left, Side)
   right = {
      input_index = 2,
      offset = 120,
      deck = nil, queue = nil, pal = nil,
   }
   setmetatable(right, Side)
end

return {
   transparent = true,
   queue = queue,

   clear = clear,
   start = function (left_deck, right_deck)
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
