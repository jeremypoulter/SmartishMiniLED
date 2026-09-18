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
EXTRA=()
command -v "$SCAD" >/dev/null || { echo "OpenSCAD not found: $SCAD" >&2; exit 1; }
TMP=$(mktemp -d)
KEEP_TMP=false
trap 'if ! $KEEP_TMP; then rm -rf "$TMP"; fi' EXIT

failed() {
    cat "$TMP/openscad.log" >&2
    echo "  FAIL  $* (diagnostics in $TMP)" >&2
    KEEP_TMP=true
    return 1
}

render() {   # render <variant> <part> <file>
    echo "  $3"
    if ! "$SCAD" -o "$3" -D "variant=\"$1\"" -D "part=\"$2\"" "$SRC" >"$TMP/openscad.log" 2>&1; then
        failed "$1: could not render $2"
        return 1
    fi
    if grep -Eq '^(WARNING|ERROR|Parser error)' "$TMP/openscad.log" || [[ ! -s "$3" ]]; then
        failed "$1: invalid render for $2"
        return 1
    fi
}

# A check part is an intersection that must come out empty. Faces that merely
# touch show up as a degenerate solid with no volume, so the test is on volume,
# not on whether OpenSCAD produced a result at all.
check() {    # check <variant> <part> <what>; EXTRA adds -D overrides
    local stl vol rc=0
    stl="$TMP/$1-$2.stl"
    rm -f "$stl"
    "$SCAD" -o "$stl" -D "variant=\"$1\"" -D "part=\"$2\"" "${EXTRA[@]}" "$SRC" >"$TMP/openscad.log" 2>&1 || rc=$?
    # A zero-volume intersection made only of touching faces can legitimately
    # produce OpenSCAD's non-manifold export warning. Validate its volume below,
    # but never accept actual model or parser errors.
    if grep -Eq '^(ERROR|Parser error)' "$TMP/openscad.log"; then
        failed "$1: $3 - OpenSCAD diagnostic"
        return 1
    fi
    # OpenSCAD 2021 exits 1 and writes no STL for a genuinely empty solid.
    # Only accept that specific diagnostic, never an arbitrary failed command.
    if [[ ! -e "$stl" && $rc -le 1 ]] && grep -Fxq 'Current top level object is empty.' "$TMP/openscad.log"; then
        echo "  ok    $1: $3"
        return 0
    fi
    if [[ $rc -ne 0 || ! -s "$stl" ]]; then
        failed "$1: $3 - no valid check result"
        return 1
    fi
    if vol=$(python3 stl_volume.py "$stl" 0.01); then
        echo "  ok    $1: $3"
        rm -f "$stl"
    else
        failed "$1: $3 - ${vol} mm3 of overlap (see $stl)"
        return 1
    fi
}

do_check() {
    echo "Checking:"
    local rc=0
    EXTRA=()
    for v in $VARIANTS; do
        check "$v" fitcheck   "case clears the populated board" || rc=1
        check "$v" clashcheck "lid clears the base"             || rc=1
        check "$v" cablecheck "cable entries are open"           || rc=1
    done
    # and again with the optional features switched on
    EXTRA=(-D ir_window=true -D button=true -D mount_ears=false)
    for v in $VARIANTS; do
        check "$v" fitcheck   "clears the board, IR + button, no lugs" || rc=1
        check "$v" clashcheck "lid clears the base, IR + button, no lugs" || rc=1
        check "$v" cablecheck "cable entries open, IR + button, no lugs" || rc=1
    done
    EXTRA=(-D tie_slot=false -D mount_ears=false)
    for v in $VARIANTS; do
        check "$v" cablecheck "cable entries open without saddles or lugs" || rc=1
    done
    EXTRA=()
    return $rc
}

do_render() {
    echo "Rendering into $OUT/:"
    mkdir -p "$OUT"
    for v in $VARIANTS; do
        for p in base lid; do
            render "$v" "$p" "$OUT/smartishminiled_${v}_${p}.stl" || return 1
        done
    done
    render usb plunger "$OUT/smartishminiled_button_plunger.stl"
}

case "${1:---render}" in
    --check)  do_check ;;
    --all)    do_check && do_render ;;
    --render) do_render ;;
    *)        echo "Usage: $0 [--render|--check|--all]" >&2; exit 1 ;;
esac
