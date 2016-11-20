local letters = "abcdefghijklmnopqrstuvwxyz"
local numbers = "1234567890"

return {
   std15 = love.graphics.newImageFont(
      "img/fonts/standard.png", " " .. letters),
   tiny = love.graphics.newImageFont(
      "img/fonts/tiny.png", " " .. letters .. numbers .. "."),
}
