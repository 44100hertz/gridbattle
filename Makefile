TMXMAPS:=$(wildcard world/maps/*/map.tmx)
LUAMAPS:=$(patsubst %.tmx,%.lua,$(TMXMAPS))

run: all
	love .

all: $(LUAMAPS)

%map.lua: %map.tmx
	tiled --export-map $< $@

.PHONY: all run
