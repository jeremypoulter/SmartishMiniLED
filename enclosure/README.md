# SmartishMiniLED enclosure

A parametric, 3D printable case for the SmartishMiniLED board. Two parts that
clip together, cable strain relief at both ends, and **no support material
anywhere** in either half.

Everything is generated from one OpenSCAD file,
[`smartishminiled_case.scad`](smartishminiled_case.scad).

![exploded view](img/exploded.png)

## Variants

| | `usb` | `hardwired` | `outdoor` |
|---|---|---|---|
| | ![](img/usb.png) | ![](img/hardwired.png) | ![](img/outdoor.png) |
| Power in | USB-C plug into J1 | cable soldered to the J4 pads | cable soldered to the J4 pads |
| Cable entries | LED strip only | LED strip + power | LED strip + power, sealed |
| Held together by | 8 snap fingers | 8 snap fingers | 8 snap fingers + 4 M3 screws |
| Sealing | none | none | 2 mm silicone cord gasket, sealed button, blind IR/LED windows |
| Button | printed plunger | printed plunger | moulded-in flexing membrane |
| Mounting lugs | optional | optional | yes |
| Outside size (mm) | 45.6 × 75.8 × 21.7 | 45.6 × 88.0 × 21.7 | 50.4 × 92.8 × 22.7 (57.7 across the lugs) |

Lengths include the strain relief snouts; widths include the antenna lobe.

## What the board dictates

The shape is not arbitrary - it is driven by what is actually on the PCB
(all figures measured out of `SmartishMiniLED.kicad_pcb`, board origin at the
corner nearest the IR receiver):

| Feature | Where | What the case does |
|---|---|---|
| Board outline | 30 × 60 × 1.6 mm | 0.7 mm side clearance |
| M3 mounting holes | 3.5 mm in from each corner, 23 × 53 mm pitch | stand-offs below, bosses above, optional M3 screws |
| **U1 ESP32-WROOM-32D** | the module is mounted so the antenna **overhangs the right hand board edge by 6.2 mm** (y 21.8 - 39.8) | the case grows a lobe on that side with ~1.2 mm of air around the antenna tip |
| **U5 IR receiver** | overhangs the left edge by 1.2 mm and looks sideways out of it | 6 × 6 mm window in the left wall, on the parting line |
| J1 USB-C | on the front edge, opening 3.3 mm above the board | 13 × 7.8 mm opening, big enough for the moulded boot of a plug, with a lead-in flare |
| J4 power pads | **underside**, right behind the USB connector | hardwired variants get an 8 mm wiring chamber at that end so the cable can curve down and back under the board |
| P1/P2 LED strip pads, J3 terminal block | far end of the board | 4 mm wiring chamber, cable snout in line with the pads |
| C6 (10 mm can), J3 (10.2 mm) | tallest parts | 11.6 mm of headroom under the lid |
| SW2 | underside, middle of the board | button in the floor |
| D2/D3 status LEDs | far end, top side | 2.6 mm windows in the lid roof |

## Why it needs no supports

* The parting line sits **exactly on the top face of the PCB**. Every opening in
  a wall (USB, IR window, both cable entries) straddles that line, so in each
  half it is a notch that is open at the joint - there is nothing to bridge.
* The base has a completely flat outside face: no feet, no protruding bosses.
  The screw heads go into 90° countersinks, which are 45° cones.
* The lid prints roof-down; its bosses, lip and snap fingers all point up.
* The strain relief snouts are 45° cones where they meet the wall, so they are
  self supporting even though they stick out into mid air.
* The only down-facing features left are 0.45 mm ledges (the snap barbs and
  their catch grooves) and a 1.9 mm ledge around the button dish. `build.sh`
  keeps that honest - see [Checks](#checks).

## Printing

| | |
|---|---|
| Orientation | **base**: as exported, flat face on the bed. **lid**: rotate 180° about X so the roof is on the bed (or use your slicer's "place on face"). **plunger**: flange down. |
| Supports | none |
| Layer height | 0.2 mm |
| Perimeters | 3 (the snap fingers want solid walls) |
| Infill | 20 % |
| Material | PLA or PETG indoors. **ASA or PETG for the outdoor case** - PLA creeps and goes brittle in UV. |

PETG or ASA also give the snap fingers and the button membrane a lot more
working strain than PLA does.

## Assembly

1. **Solder the tails on first** - the LED strip wires to P1/P2 (or into J3),
   and, on the hardwired variants, the power pair to J4 on the underside.
2. Feed each cable in through its snout from the outside before dropping the
   board in.
3. `usb` / `hardwired`: drop the **plunger** into the hole in the floor of the
   base, flange side up.
4. Sit the board on the four stand-offs. Without screws, the spigots on the
   stand-offs locate it through the mounting holes.
5. Route the cables over the tie rib and, if you want a positive anchor, pass a
   small cable tie through the slot in the rib and around the cable.
6. Press the lid on until all eight fingers click. The bosses in the lid land on
   the board and hold it down.
7. `outdoor`: lay the silicone cord in the groove in the rim of the base
   (roughly 250 mm - lay it in and cut to length, superglue the butt joint),
   then fit 4 × M3 × 16 countersunk screws from underneath. They pass through
   the board and thread into the bosses in the lid.

To open: there is a pry notch in the outer edge of the lid on each long side -
twist a spudger or a small screwdriver in one of those. Take the screws out
first on the outdoor version.

## Cable relief

Each cable entry has three things working on it:

* a tapered snout that stops the cable bending sharply where it leaves the case;
* three ribs inside the bore that stand 0.45 mm proud and bite into the jacket
  when the two halves are closed onto it;
* a tie rib just inside, with a slot for a cable tie so that pull on the cable
  is taken by the base rather than by the solder joints.

The bores are 4.5 mm (LED strip) and 5.0 mm (power) - change `cable_d_led` and
`cable_d_pwr` to match the cable you actually have. The clamp wants the cable to
be a *snug* fit; if the halves will not close, the cable is too big for the bore.

On the **outdoor** variant the bore opens out into a seat for a compression
grommet: push a 10 mm length of 8 mm OD silicone tube (or a rubber grommet) over
the cable, sit it in the seat, and tightening the screws squeezes it onto the
jacket. If you would rather use an off-the-shelf gland, set `grommet_d` to the
thread diameter of a PG7 / M12 gland and fit the nut inside.

## Bill of materials

| Variant | Parts |
|---|---|
| `usb` | 2 printed parts + 1 plunger. Optional: 1 small cable tie |
| `hardwired` | 2 printed parts + 1 plunger. Optional: 2 cable ties |
| `outdoor` | 2 printed parts, ~250 mm of 2 mm silicone O-ring cord, 4 × M3 × 16 countersunk machine screws (self tapping into the printed bosses), 2 × grommet or 8 mm silicone tube, 4 × screws to mount it |

Optional for any variant: two 3 mm acrylic rods, 11.5 mm long, as light pipes for
the status LEDs - set `led_win_d = 3.1` first.

## Customising

Open the file in OpenSCAD and use the Customizer, or override on the command
line: `openscad -D 'variant="outdoor"' -D 'part="lid"' -o lid.stl smartishminiled_case.scad`

| Parameter | Default | Notes |
|---|---|---|
| `variant` | `"usb"` | `usb`, `hardwired`, `outdoor` |
| `part` | `"base"` | `base`, `lid`, `plunger`, `assembly`, `exploded`, `section`, `fitcheck`, `clashcheck` |
| `bot_gap` / `top_gap` | 4.5 / 11.6 | clearance under and over the board |
| `cable_d_led` / `cable_d_pwr` | 4.5 / 5.0 | cable jacket diameters |
| `sw_h` | 3.0 | how far SW2 stands off the underside of the board - **measure yours**; it sets the plunger and membrane travel |
| `lobe` | `true` | set `false` only if U1 is not fitted; with it fitted the antenna does not fit inside a plain box |
| `screws` | `false` | add the M3 screws to an indoor variant |
| `mount_ears` | `false` | add the four mounting lugs to an indoor variant |
| `led_win_d` | 2.6 | 3.1 to take a 3 mm light pipe |
| `fin_barb`, `fit_clr` | 0.45, 0.30 | snap engagement and joint clearance - tighten or loosen to suit your printer |
| `wall_std`, `wall_seal` | 3.0, 5.4 | wall thickness |

The case is deliberately unvented: the only thing in it that dissipates
anything is the 3.3 V regulator and the strip MOSFET, and the LED strip itself
is outside.

## Building

```sh
./build.sh            # render every STL into ./stl
./build.sh --check    # run the clearance checks
./build.sh --all      # both
```

Needs OpenSCAD (`apt install openscad`) and python3. CI builds the same STLs on
every change under `enclosure/` and uploads them as a workflow artifact.

## Checks

The model carries a mock of the populated board - every part tall enough to
matter, including the overhanging antenna and the IR receiver - and two
intersections that have to come out empty:

* `part="fitcheck"` - the assembled case against the populated board;
* `part="clashcheck"` - the lid against the base.

`build.sh --check` renders both for all three variants and fails if either has
any volume in it. Faces that merely touch are fine; anything with volume is a
collision.

`part="assembly"`, `part="exploded"` and `part="section"` render the case with
the board in place if you want to look at it rather than measure it.
