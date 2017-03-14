return {
   paths = {
      bg = "bg/",
      fonts = "fonts/",
      chips = "chips/",
      folders = "folders/",
      menu = "menu/",
      sets = "battle/sets/",
   },
   start = function ()
      (require "src/scene").push((require "src/Menu"):new("title"))
   end
}
