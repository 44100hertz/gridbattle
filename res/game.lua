_G.GAME = {
   width = 240,
   height = 160,
}

_G.PATHS = {
   bg = "res/bg/",
   fonts = "res/fonts/",
   chips = "res/chips/",
   folders = "res/folders/",
   menu = "res/menu/",
   battle = "res/battle/",
   sets = "battle/sets/",
}

return {
   start = function ()
      (require "src/scene").push((require "src/Menu"):new("title"))
   end
}
