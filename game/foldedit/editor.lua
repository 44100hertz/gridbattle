local oop = require 'src/oop'

local folder = require 'src/folder'
local image = require 'src/image'

local editor = oop.class()

local num_entries = 12
local entry_height = 11

function editor:init ()
   self.icons = {
      [1] = oop.bind_by_name(GAME.scene, 'pop'),
      [2] = function (self)
         self.deck.folder:save()
         self.library.folder:save()
      end,
      [3] = function (self)
         self.deck.folder:load('leftpane')
         self.library.folder:load('rightpane')
      end,
      [4] = function (self)
         self.deck.folder:sort('letter')
         self.library.folder:sort('letter')
      end,
      [5] = function (self)
         self.deck.folder:sort('name')
         self.library.folder:sort('name')
      end,
      [6] = function (self)
         self.deck.folder:sort('quantity')
         self.library.folder:sort('quantity')
      end,
      [7] = function (self)
         self.deck.folder:sort('element')
         self.library.folder:sort('element')
      end,
   }
   self.column, self.selection = 2,1
   self.deck = {}
   self.deck.folder = folder('test-collection')
   self.deck.folder.name = 'leftpane'
   self.deck.sel = 1
   self.library = {}
   self.library.folder = folder('test-folder')
   self.library.folder.name = 'rightpane'
   self.library.sel = 1
   self.image = image('foldedit')
end

function editor:move_chip (from, to)
   local entry = from.folder:remove(from.sel)
   if not entry then return end
   if not from.folder.data[from.sel] then
      if from.sel < #from.folder.data then
         from.sel = from.sel + 1
      else
         from.sel = math.max(#from.folder.data, 1)
      end
   end
   to.folder:insert(entry)
end

function editor:update (input)
   input = input[1]
   -- Check input with repeat
   local function repcheck (t)
      return t % math.max(20-t, 6) == 1
   end
   local function update_pane (pane)
      if #pane.folder.data==0 then return end
      if repcheck(input.dd) then
         pane.sel = pane.sel % #pane.folder.data + 1
      elseif repcheck(input.du) then
         pane.sel = (pane.sel-2) % #pane.folder.data + 1
      end
   end

   if input.dr==1 then self.column = self.column%3+1 return end
   if input.dl==1 then self.column = (self.column-2)%3+1 return end

   if self.column==1 then
      if input.a==1 then
         self.icons[self.selection](self)
      elseif input.dd==1 then
         self.selection = self.selection % #self.icons + 1
      elseif input.du==1 then
         self.selection = (self.selection-2) % #self.icons + 1
      end
   elseif self.column==2 then
      update_pane(self.deck)
      if input.a==1 then
         self:move_chip(self.deck, self.library)
      end
   elseif self.column==3 then
      update_pane(self.library)
      if input.a==1 then
         self:move_chip(self.library, self.deck)
      end
   end
end

function editor:draw ()
   love.graphics.clear(16/255.0,24/255.0,24/255.0)

   local function draw_list (pane, x)
      if #pane.folder.data==0 then return end
      local y = 19
      local i = pane.sel - 5
      for _ = 1, num_entries do
         local line, elem_index
         local v = pane.folder.data[i]
         if not v then
            if #pane.folder.data>7 then
               v = pane.folder.data[(i-1) % #pane.folder.data+1]
               love.graphics.setColor(136/255.0,144/255.0,136/255.0)
            else
               goto continue
            end
         end
         -- Highlight selection
         if i == pane.sel then love.graphics.setColor(120/255.0, 192/255.0, 128/255.0) end

--         -- element symbol
--         elem_index = elements.by_name[GAME.chipdb[v.name].elem]
--         line = string.char(elem_index) .. v.ltr:upper() .. ' ' .. v.name
         line = v.ltr:upper() .. ' ' .. v.name
         love.graphics.print(line, x, y)
         love.graphics.print('x' .. v.qty, x+78, y)
         love.graphics.setColor(1.0, 1.0, 1.0)
         ::continue::
         y = y + entry_height
         i = i + 1
      end
   end

   draw_list(self.deck, 24)
   draw_list(self.library, 136)

  self.image:set_sheet'fg'
   self.image:draw(16, 0)
   love.graphics.print('Collection', 24, 8)
   local right_str = 'folder (' .. self.library.folder:count() .. '/30' .. ')'
   love.graphics.print(right_str, 136, 8)

   -- Selection rectangle around column
   local function draw_col_sel (x)
      love.graphics.setColor(120/255.0, 192/255.0, 128/255.0)
      love.graphics.rectangle('line', x+1.5, 1.5, 109, 157)
      love.graphics.setColor(1.0, 1.0, 1.0)
   end
   if self.column==2 then draw_col_sel(16) end
   if self.column==3 then draw_col_sel(128) end

   -- Icons on left
   self.image:set_sheet'icons'
   for i = 1,#self.icons do
      local is_sel = (self.column==1 and self.selection==i) and 2 or 1
      self.image:draw(0, i*16, nil, (i-1)*2 + is_sel)
   end
end

return editor
