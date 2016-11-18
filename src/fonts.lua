local asciitable = {}
for i = 32,126 do
   asciitable[i-31] = i
end
local asciistring = " abcdefghijklmnopqrstuvwxyz"

fonts = {
   std15 = love.graphics.newImageFont("img/font.png", asciistring)
}
