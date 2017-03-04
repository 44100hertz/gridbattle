local text = require "src/text"

local phrase = "This is a test of how effective the word wrapping technique is. Please subscribe, please don't die, programming video games, FOREVER."

print(text.wrap(phrase, 2))
