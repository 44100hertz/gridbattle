--[[
### Sheet ###
a set of quads for sprite/tile sheet
reads data from sheet data file
currently returns a love.graphics.draw instruction for that given sheet

sheet_data format:
sheet = {
   size = {x=_, y=_}       ; default size in pixels
   img = _                 ; image filename to make sheet from. Can be overridden.
   {                       ; start of a strip
       size = {x=_, y=_}   ; optional per-strip size
       pos = {x=_, y=_}    ; upper-left corner of strip
       num = _             ; number of frames to be read left-to-right
   },
   {
       ...                 ; next strip
   },
}
--]]

Sheet = {}

-- Read a strip, return the quads
local function read_strip(offset, size, img_size, num)
   local x
   local quads = {}
   for x = 0, num do
      quads[x+1] = love.graphics.newQuad(
	 offset.x, offset.y,
	 size.x, size.y,
	 img_size.x, img_size.y)
   end
   return quads
end

--[[ Create a new sheet based on sheet_data
   'img' should be a love.graphics.image, is optional, and overrides the sheet
   returns a table of named strips, with numbered love quads
--]] 
function Sheet.new(sheet, img)
   local o = {}
   o.img = img or assert(love.graphics.newImage(sheet.file))

   -- Parameters outside "strip"
   local img_size = {}
   img_size.x, img_size.y = o.img:getDimensions()
   local default_size = sheet.size

   -- Read each strip
   for k,_ in pairs(sheet.strips) do
      local size = sheet.strips[k].size or default_size
      o[k] = read_strip(
	 sheet.strips[k].pos,
	 size,
	 img_size,
	 sheet.strips[k].num
      )
   end
   
   return o
end

return Sheet
