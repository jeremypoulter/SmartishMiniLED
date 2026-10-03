#!/usr/bin/env bash
# Regenerate the preview pictures in ./img used by the README.
#
#   ./render_images.sh
#
# Needs OpenSCAD and, on a machine without a display, xvfb-run.

set -euo pipefail
cd "$(dirname "$0")"

SCAD=${OPENSCAD:-openscad}
SRC=smartishminiled_case.scad
OUT=${OUT:-img}
RUN=()
if [[ -z ${DISPLAY:-} ]] && command -v xvfb-run >/dev/null; then
    RUN=(xvfb-run -a)
fi
mkdir -p "$OUT"

render() {   # render <file> <size> <eye> <centre> <openscad args...>
    local file=$1 size=$2 eye=$3 centre=$4
    shift 4
    echo "  $OUT/$file"
    "${RUN[@]}" "$SCAD" -o "$OUT/$file" --imgsize="$size" --camera="$eye,$centre" \
        --projection=p --colorscheme=Tomorrow --render '' "$@" "$SRC" >/dev/null 2>&1
}

echo "Rendering into $OUT/:"
render usb.png       1100,820  150,-115,105  15,35,3   -D 'variant="usb"'       -D 'part="assembly"'
render hardwired.png 1100,820  150,-115,105  15,28,3   -D 'variant="hardwired"' -D 'part="assembly"'
render outdoor.png   1100,820  150,-115,105  15,28,3   -D 'variant="outdoor"'   -D 'part="assembly"'
render exploded.png  1200,1000 150,-115,105  15,30,18  -D 'variant="usb"'       -D 'part="exploded"' -D button=true
render cable_exit.png 1100,820  105,165,80  15,62,2  -D 'variant="usb"'       -D 'part="assembly"'
