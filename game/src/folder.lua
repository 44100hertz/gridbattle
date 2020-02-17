local serialize = require 'src/serialize'
local oop = require 'src/oop'

local folder = oop.class()

function folder:init(name)
   self.temp_count = nil
   self.name = name
--   local path = 'folders/' .. name .. '.lua'
   -- Look first in save dir, then in game folders.
--   if love.filesystem.getInfo(path) then
--      self.data = love.filesystem.load()()
--   else
   self.data = love.filesystem.load('folders/' .. name .. '.lua')()
--   end
end

function folder:save(name)
   if name then self.name = name end
   local outdir = 'folders/'
   love.filesystem.createDirectory(outdir)
   serialize.to_config(
      love.filesystem.getSaveDirectory()
         .. '/' .. outdir .. self.name, self.data)
end

-- Sort a folder using a specific method.
-- @method: How to sort. If the specified method doesn't work, uses a priority
--          list.
-- @reverse: If true, switch the default sort upside down.
function folder:sort(method, reverse)
   local fetch_functions = {
      letter  = function (chip) return chip.letter end,
      name    = function (chip) return chip.name end,
      amount  = function (chip) return -chip.amount end,
      element = function (chip) return GAME.chipdb[chip.name].element end,
   }
   local method_priority_lists = {
      letter  = {'letter', 'name'},
      name    = {'name', 'letter'},
      amount  = {'amount', 'letter', 'name'},
      element = {'element', 'letter', 'name'},
   }
   local priority_list = method_priority_lists[method]

   local sort_function = function (a,b)
      for _,method in ipairs(priority_list) do
         local fetch = fetch_functions[method]
         local a_val,b_val = fetch(a), fetch(b)
         if a_val < b_val then return not reverse end
         if a_val > b_val then return reverse end
      end
      return not reverse
   end

   table.sort(self.data, sort_function)
end

function folder:condense()
   for i,a in ipairs(self.data) do
      for j = i+1,#self.data do
         local b = self.data[j]
         if a.name == b.name and
            a.letter == b.letter
         then
            a.amount = a.amount + b.amount
            b.amount = 0
         end
      end
   end
   for _,v in ipairs(self.data) do
      if v.amount == 0 then table.remove(self.data, v) end
   end
end

function folder:find(entry)
   for i=1,#self.data do
      if self.data[i].name == entry.name and
         self.data[i].letter == entry.letter
      then
         return i
      end
   end
end

function folder:insert(entry)
   self.temp_count = nil
   local i = self:find(entry)
   if i then
      self.data[i].amount = self.data[i].amount + 1
   else
      entry.amount = 1
      table.insert(self.data, entry)
   end
end

function folder:remove(index)
   self.temp_count = nil
   index = index or love.math.random(#self.data)
   local entry = self.data[index]
   if not entry then
      print('tried to remove nonexistant index:', index)
      return
   end
   if not GAME.debug.endless_folder then
      entry.amount = entry.amount - 1
   end
   if entry.amount==0 then table.remove(self.data, index) end
   return {name = entry.name, letter = entry.letter}
end

function folder:count()
   if not self.temp_count then
      self.temp_count = 0
      for _,v in ipairs(self.data) do
         self.temp_count = self.temp_count + v.amount
      end
   end
   return self.temp_count
end

-- Draw a folder, optionally fill a palette
function folder:draw(num, pal)
   pal = pal or {}
   for i=1,num do
      if not pal[i] then
         pal[i] = self:remove()
      end
   end
   return pal
end

return folder
