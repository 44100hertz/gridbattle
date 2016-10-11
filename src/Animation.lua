local ben = require "battle/anim/ben"

Animation = {}

local function read_row(size, quad_size, row, cols)
   local x
   local quads = {}
   for x = 0, cols do
      quads[x+1] =
	 love.graphics.newQuad(
	    quad_size.x*x, quad_size.y*row,
	    quad_size.x, quad_size.y,
	    size.x, size.y
	 )
   end
   return quads
end

function Animation:drawFrame(name, time)
end

function Animation:new(sheet)
   img = love.graphics.newImage(sheet.file)
   width, height = img:getDimensions()
   local animation = {}
   for k,_ in ipairs(sheet) do
      animation[sheet[k].name] = read_row(
	 sheet.size, {x=width, y=height},
	 sheet[k].row, sheet[k].cols
      )
      local time = 0;
      for i,_ in ipairs(sheet[k].duration) do
	 animation.time = sheet[k].duration[i] + time
      end
   end
   return animation
end
