local letters = "abcdefghijklmnopqrstuvwxyz"
local numbers = "1234567890"

return {
   std15 = love.graphics.newImageFont(
      "res/fonts/standard.png", " " .. letters .. "':()/"),
   tiny = love.graphics.newImageFont(
      "res/fonts/tiny.png", " " .. letters .. numbers .. "."),
   tinyhp = love.graphics.newImageFont(
      "res/fonts/tinyhp.png", " " .. numbers),
}
