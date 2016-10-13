--[[
### Sheet ###
a set of quads for sprite/tile sheet
reads data from sheet data file
currently returns a love.graphics.draw instruction for that given sheet

sheet_data format:
{
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
   for x=1, num do
      quads[x] = love.graphics.newQuad(
	 offset.x + (x-1) * size.x, offset.y,
	 size.x, size.y,
	 img_size.x, img_size.y)
   end
   return quads
end

--[[ Create a new sheet based on data
   'img' should be a love.graphics.image, is optional, and overrides the sheet
   returns a table of named strips, with numbered love quads
--]]
function Sheet.new(data, img)
   local sheet = {}
   sheet.img = img or assert(love.graphics.newImage(data.file))

   -- Parameters outside "strip"
   local img_size = {}
   img_size.x, img_size.y = sheet.img:getDimensions()
   local default_size = data.size

   -- Read each strip
   for k,_ in pairs(data.strips) do
      local size = data.strips[k].size or default_size
      sheet[k] = read_strip(
	 data.strips[k].pos,
	 size,
	 img_size,
	 data.strips[k].num
      )
   end
   
   return sheet
end

return Sheet
