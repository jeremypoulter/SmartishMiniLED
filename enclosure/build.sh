#!/usr/bin/env bash
# Build (and sanity check) the SmartishMiniLED enclosure.
#
#   ./build.sh            render every STL into ./stl
#   ./build.sh --check    run the built in clearance checks only
#   ./build.sh --all      check, then render
#
# Needs OpenSCAD on the PATH (or set $OPENSCAD).

set -euo pipefail
cd "$(dirname "$0")"

SCAD=${OPENSCAD:-openscad}
SRC=smartishminiled_case.scad
OUT=${OUT:-stl}
VARIANTS=${VARIANTS:-"usb hardwired outdoor"}
EXTRA=""

render() {   # render <variant> <part> <file>
    echo "  $3"
    "$SCAD" -o "$3" -D "variant=\"$1\"" -D "part=\"$2\"" "$SRC" 2>&1 \
        | grep -E '^(WARNING|ERROR)' && exit 1
    return 0
}

# A check part is an intersection that must come out empty. Faces that merely
# touch show up as a degenerate solid with no volume, so the test is on volume,
# not on whether OpenSCAD produced a result at all.
check() {    # check <variant> <part> <what>; $EXTRA adds -D overrides
    local stl vol
    stl=$(mktemp -u --suffix=.stl)
    # shellcheck disable=SC2086
    "$SCAD" -o "$stl" -D "variant=\"$1\"" -D "part=\"$2\"" $EXTRA "$SRC" >/dev/null 2>&1 || true
    if vol=$(python3 stl_volume.py "$stl" 0.01); then
        echo "  ok    $1: $3"
        rm -f "$stl"
    else
        echo "  FAIL  $1: $3 - ${vol} mm3 of overlap (see $stl)"
        return 1
    fi
}

do_check() {
    echo "Checking:"
    local rc=0
    EXTRA=""
    for v in $VARIANTS; do
        check "$v" fitcheck   "case clears the populated board" || rc=1
        check "$v" clashcheck "lid clears the base"             || rc=1
    done
    # and again with the optional features switched on
    EXTRA="-D ir_window=true -D button=true"
    for v in $VARIANTS; do
        check "$v" fitcheck   "clears the board, IR window + button" || rc=1
        check "$v" clashcheck "lid clears the base, IR window + button" || rc=1
    done
    EXTRA=""
    return $rc
}

do_render() {
    echo "Rendering into $OUT/:"
    mkdir -p "$OUT"
    for v in $VARIANTS; do
        for p in base lid; do
            render "$v" "$p" "$OUT/smartishminiled_${v}_${p}.stl"
        done
    done
    render usb plunger "$OUT/smartishminiled_button_plunger.stl"
}

case "${1:---render}" in
    --check)  do_check ;;
    --all)    do_check && do_render ;;
    *)        do_render ;;
esac
