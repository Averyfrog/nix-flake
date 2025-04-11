#!/usr/bin/env bash

if grim -g "$(slurp)" - > ~/.cache/tmpscreenshot.png ; then
  notify-send 'Screenshot taken' 'copied to clipboard' -i ~/.cache/tmpscreenshot.png
fi

wl-copy < ~/.cache/tmpscreenshot.png
