local letters = "abcdefghijklmnopqrstuvwxyz"
local numbers = "1234567890"

return {
      std15 = love.graphics.newImageFont("img/font.png", " " .. letters),
      tiny = love.graphics.newImageFont("img/font-tiny.png", " " .. letters .. numbers),
}
