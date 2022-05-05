#!/bin/bash

# see man zscroll for documentation of the following parameters
zscroll -l 30 \
  --delay 0.1 \
  --match-command "$(dirname $0)/media-controller.sh --title" \
  --update-check true "$(dirname $0)/media-controller.sh --title" &

wait

# --match-text "Playing" "--scroll 1" \
# --match-text "Paused" "--scroll 0" \
