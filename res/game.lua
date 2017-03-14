return {
   paths = {
      bg = "res/bg/",
      fonts = "res/fonts/",
      chips = "res/chips/",
      folders = "res/folders/",
      menu = "res/menu/",
      sets = "battle/sets/",
   },
   start = function ()
      (require "src/scene").push((require "src/Menu"):new("title"))
   end
}
