local main = require "main"

return {
   {  x=100, y=100, text="pause",
      a = function () main.popstate() end
   }
}
