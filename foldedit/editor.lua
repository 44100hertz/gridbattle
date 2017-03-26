local Folder = require "src/Folder"
local text = require "src/text"
local chipdb = require(PATHS.chipdb)

local lg = love.graphics

local img = lg.newImage(PATHS.foldedit .. "editor.png")
local sheet = (require "src/quads").multi_sheet{
   img = img,
   fg = {32,0,224,160},
   icons = {0,0,16,16,2,7},
}

local pane_left = {}
local pane_right = {}

local scene = require "src/scene"
local col1 = {
   [1] = scene.pop,
   [2] = function ()
      pane_left.folder:save()
      pane_right.folder:save()
   end,
   [3] = function ()
      pane_left.folder:load("leftpane")
      pane_right.folder:load("rightpane")
   end,
   [4] = function ()
      pane_left.folder:sort("letter")
      pane_right.folder:sort("letter")
   end,
   [5] = function ()
      pane_left.folder:sort("name")
      pane_right.folder:sort("name")
   end,
   [6] = function ()
      pane_left.folder:sort("quantity")
      pane_right.folder:sort("quantity")
   end,
   [7] = function ()
      pane_left.folder:sort("element")
      pane_right.folder:sort("element")
   end,
}

local col, sel
local num_entries = 12
local entry_height = 11

local move_chip = function (from, to)
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

return {
   start = function (collection, folder)
      col, sel = 2,1
      pane_left.folder = Folder.load({}, "test-collection")
      pane_left.folder.name = "leftpane"
      pane_left.sel = 1
      pane_right.folder = Folder.load({}, "test-folder")
      pane_right.folder.name = "rightpane"
      pane_right.sel = 1
   end,

   update = function (_, input)
      input = input[1]
      -- Check input with repeat
      local repcheck = function (t)
         return t % math.max(20-t, 6) == 1
      end
      local update_pane = function (pane)
         if #pane.folder.data==0 then return end
         if repcheck(input.dd) then
            pane.sel = pane.sel % #pane.folder.data + 1
         elseif repcheck(input.du) then
            pane.sel = (pane.sel-2) % #pane.folder.data + 1
         end
      end

      if input.dr==1 then col = col%3+1 return end
      if input.dl==1 then col = (col-2)%3+1 return end

      if col==1 then
         if input.a==1 then
            col1[sel]()
         elseif input.dd==1 then
            sel = sel % #col1 + 1
         elseif input.du==1 then
            sel = (sel-2) % #col1 + 1
         end
      elseif col==2 then
         update_pane(pane_left)
         if input.a==1 then
            move_chip(pane_left, pane_right)
         end
      elseif col==3 then
         update_pane(pane_right)
         if input.a==1 then
            move_chip(pane_right, pane_left)
         end
      end
   end,

   draw = function ()
      lg.clear(16,24,24)

      local draw_list = function (pane, x)
         if #pane.folder.data==0 then return end
         local y = 19
         local i = pane.sel - 5
         for _ = 1, num_entries do
            local line
            local v = pane.folder.data[i]
            if not v then
               if #pane.folder.data>7 then
                  v = pane.folder.data[(i-1) % #pane.folder.data+1]
                  lg.setColor(136,144,136)
               else
                  goto continue
               end
            end
            -- Highlight selection
            if i == pane.sel then lg.setColor(120, 192, 128) end

            line = string.char(chipdb[v.name].elem) ..
               v.ltr:upper() .. " " .. v.name
            text.draw("flavor", line, x, y)
            text.draw("flavor", "\127" .. v.qty, x+78, y)
            lg.setColor(255, 255, 255)
            ::continue::
            y = y + entry_height
            i = i + 1
         end
      end

      draw_list(pane_left, 24)
      draw_list(pane_right, 136)

      lg.draw(img, sheet.fg, 16)
      text.draw("flavor", "Collection", 24, 8)
      local right_str = "Folder (" .. pane_right.folder:count() .. "/30" .. ")"
      text.draw("flavor", right_str, 136, 8)

      -- Selection rectangle around column
      local draw_col_sel = function (x)
         lg.setColor(120, 192, 128)
         lg.rectangle("line", x+1.5, 1.5, 109, 157)
         lg.setColor(255, 255, 255)
      end
      if col==2 then draw_col_sel(16) end
      if col==3 then draw_col_sel(128) end

      -- Icons on left
      for i,v in ipairs(sheet.icons) do
         local is_sel = (col==1 and sel==i) and 2 or 1
         lg.draw(img, v[is_sel], 0, i*16)
      end
   end,
}
