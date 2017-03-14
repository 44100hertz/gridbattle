return {
   paths = {
      bg = "res/bg/",
      fonts = "res/fonts/",
      chips = "res/chips/",
      folders = "res/folders/",
      menu = "res/menu/",
      sets = "res/battle/sets/",
   },
   start = function ()
      (require "src/scene").push((require "src/Menu"):new(require "res/menu/title"))
   end
}
