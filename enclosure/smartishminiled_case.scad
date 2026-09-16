// ============================================================================
//  SmartishMiniLED - 3D printable enclosure
// ----------------------------------------------------------------------------
//  Two part snap-fit case for the SmartishMiniLED PCB (30 x 60 x 1.6 mm).
//
//  Three variants:
//    "usb"        - USB-C receptacle (J1) exposed through the front wall
//    "hardwired"  - no USB opening, power cable clamped into a strain relief
//                   snout and soldered to the J4 pads on the bottom of the PCB
//    "outdoor"    - hardwired + silicone cord gasket, sealed membrane button,
//                   sealed IR/LED windows, compression grommet cable entries
//                   and four M3 screws through the PCB mounting holes
//
//  U5 (IR receiver) and SW2 (button) are usually left unpopulated, so the
//  window and the button are off by default - see ir_window / button.
//
//  Everything prints without support material: the parting line sits exactly
//  on the top face of the PCB, so every wall opening (USB, IR, cable entries)
//  is a notch that is open at the parting line in both halves.
//
//  All dimensions are in millimetres, in *board coordinates*:
//      X = 0..30  across the PCB (0 = edge nearest the IR receiver U5)
//      Y = 0..60  along the PCB  (0 = USB-C end, 60 = LED strip pad end)
//      Z = 0      top face of the PCB (= the parting line)
// ============================================================================

/* [Build] */
// Which case to build
variant = "usb";        // [usb, hardwired, outdoor]
// Which piece to render / export
part    = "base";       // [base, lid, plunger, assembly, exploded, section, fitcheck, clashcheck]

/* [PCB] */
pcb_w       = 30.0;     // board width  (X)
pcb_l       = 60.0;     // board length (Y)
pcb_t       = 1.6;      // board thickness
hole_inset  = 3.5;      // mounting hole centres, in from each corner
hole_d      = 3.2;      // mounting hole diameter

/* [Optional parts] */
// U5 and SW2 are not fitted on a standard build (they are in the "ignore" list
// for assembly), so neither feature is cut by default.
// Turning the IR window on also widens the case by 1.5 mm, which is the room
// the MINICAST package needs where it hangs over the board edge.
ir_window   = false;    // window in the left wall for the IR receiver U5
button      = false;    // way through the floor to the button SW2

/* [Internal envelope] */
// Air gap between the board edge and the inner wall.
gap_right   = 0.7;      // X>30
gap_back    = 4.0;      // Y>60  - wiring chamber for the LED strip tails
gap_front   = 0.8;      // Y<0   - "usb" variant (connector sits on the edge)
tail_front  = 8.0;      // Y<0   - hardwired/outdoor wiring chamber
bot_gap     = 4.5;      // under the board (SW2 button + wire routing)
top_gap     = 11.6;     // over the board  (C6 10 mm, J3 terminal block 10.2 mm)

// The ESP32-WROOM module (U1) is fitted with its antenna hanging 6.2 mm past
// the right hand board edge, so the case grows a lobe around it.
lobe        = true;
lobe_x      = 37.4;     // inner face of the lobe (antenna tip is at x=36.21)
lobe_y0     = 18.0;
lobe_y1     = 43.5;

/* [Shell] */
wall_std    = 3.0;      // wall thickness, indoor variants
wall_seal   = 5.4;      // wall thickness, gasketed outdoor variant
floor_t     = 2.0;      // floor thickness, indoor variants
floor_seal  = 3.0;      // floor thickness, outdoor (room for the countersinks)
ceil_t      = 2.0;
r_in        = 1.6;      // inner corner radius
r_blend     = 4.0;      // fillet where the antenna lobe meets the body

/* [Snap fit] */
lip_t       = 1.2;      // continuous alignment lip on the lid
lip_h       = 2.2;
fin_w       = 7.0;      // snap finger width
fin_h       = 5.8;      // snap finger length
fin_t_root  = 1.30;     // tapered for a lower peak strain
fin_t_tip   = 0.90;
fin_barb    = 0.45;     // barb height (0.30 of it is live engagement)
fit_clr     = 0.30;     // running clearance between the two halves

/* [Cables] */
cable_d_led = 4.5;      // LED strip tail, at Y=60
cable_d_pwr = 5.0;      // power tail, at Y=0 (hardwired / outdoor)
snout_len   = 5.0;      // strain relief snout length
grommet_d   = 8.0;      // outdoor: silicone tube / rubber grommet OD
grommet_l   = 8.0;
tie_slot    = true;     // internal cable tie anchor

/* [Openings] */
usb_w       = 13.0;     // clears the moulded boot of a USB-C plug
usb_h       = 7.8;
usb_z       = 1.3;      // centre height of the USB opening
ir_w        = 6.0;      // IR receiver window (U5, left wall)
ir_h        = 6.0;
ir_z        = 0.6;
led_win_d   = 2.6;      // status LED windows (D2, D3) in the lid

/* [Hardware] */
screws      = false;    // M3 countersunk, through the PCB mounting holes
gasket_d    = 2.0;      // silicone cord gasket diameter (outdoor)
mount_ears  = false;    // four flat mounting lugs (always on for outdoor)
ear_t       = 3.0;
ear_out     = 7.0;      // how far a lug sticks out past the wall
ear_w       = 11.0;
ear_hole_d  = 4.3;

/* [Board fitted parts] */
sw_h        = 3.0;      // SW2 stand-off below the PCB (E-Switch TL3342)
btn_gap     = 0.30;     // rest gap between the plunger and the switch

/* [Hidden] */
$fs = 0.4;
$fa = 3;
eps = 0.01;

// ---------------------------------------------------------------------------
//  Derived
// ---------------------------------------------------------------------------
sealed   = (variant == "outdoor");
hardwire = (variant == "hardwired") || sealed;

wall       = sealed ? wall_seal : wall_std;
floor_th   = sealed ? floor_seal : floor_t;
use_screws = sealed ? true : screws;
use_ears   = sealed ? true : mount_ears;

// U5 overhangs the left board edge by 1.22 mm, but only if it is fitted
gap_left = ir_window ? 2.2 : 0.7;

x0 = -gap_left;                 // inner face, left
x1 = pcb_w + gap_right;         // inner face, right (main body)
y0 = hardwire ? -tail_front : -gap_front;
y1 = pcb_l + gap_back;

z_pcb_bot   = -pcb_t;
z_floor_top = -(pcb_t + bot_gap);
z_bot       = z_floor_top - floor_th;
z_ceil      = top_gap;              // inner face of the lid roof
z_top       = top_gap + ceil_t;     // outside of the lid

barb_h    = 1.6;                    // height of the barb on each finger
snap_play = 0.05;                   // lost motion in the closed snap
rebate_t = lip_t + fit_clr;         // the base wall is set back by this much
pocket_t = fin_t_root + 0.25;       // local set back at each snap finger
groove_t = pocket_t + fin_barb + 0.10;
fin_face = pocket_t - 0.15;         // the outer face of a finger rides here

// mounting hole centres
holes = [ [hole_inset, hole_inset],
          [pcb_w - hole_inset, hole_inset],
          [hole_inset, pcb_l - hole_inset],
          [pcb_w - hole_inset, pcb_l - hole_inset] ];

// snap fingers: [x, y, rotation] - the finger grows along +Y of its own frame,
// which after the rotation points out of the wall it belongs to.
fingers = concat(
    [ [x0,  9.0,  90], [x0, 52.0,  90],          // left wall
      [x1,  9.0, -90], [x1, 52.0, -90],          // right wall
      [ 8.0, y1,   0], [23.0, y1,   0] ],        // back wall
    hardwire ? [ [8.0, y0, 180], [23.0, y0, 180] ]
             : [ [4.5, y0, 180], [24.5, y0, 180] ] );

// cable entries: [x, y of the outer wall face, outward direction, bore]
entries = concat(
    [ [15.0, y1 + wall,  1, cable_d_led] ],
    hardwire ? [ [15.0, y0 - wall, -1, cable_d_pwr] ] : [] );

echo(str("variant=", variant,
         "  body X=", (lobe ? lobe_x : x1) + wall - (x0 - wall),
         "  Y=", (y1 + wall) - (y0 - wall) + snout_len * len(entries),
         "  Z=", z_top - z_bot));

// ---------------------------------------------------------------------------
//  2D profiles
// ---------------------------------------------------------------------------
module rrect(ax, ay, bx, by, r) {
    translate([ax + r, ay + r])
        offset(r = r) square([bx - ax - 2 * r, by - ay - 2 * r]);
}

// inner face of the shell
module inner2d() {
    offset(r = -r_blend) offset(r = r_blend) union() {   // fillet the lobe root
        rrect(x0, y0, x1, y1, r_in);
        if (lobe) rrect(x1 - 2, lobe_y0, lobe_x, lobe_y1, r_in);
    }
}

module outer2d() { offset(r = wall) inner2d(); }

// ---------------------------------------------------------------------------
//  Half space helpers - everything that straddles the parting line is built
//  once and then clipped, so the two halves always match.
// ---------------------------------------------------------------------------
module clip_lower() {
    intersection() {
        children();
        translate([-200, -200, z_bot]) cube([400, 400, -z_bot]);
    }
}
module clip_upper() {
    intersection() {
        children();
        translate([-200, -200, 0]) cube([400, 400, z_top]);
    }
}

// ---------------------------------------------------------------------------
//  Cable entries
// ---------------------------------------------------------------------------
// Tapered snout. Every face is at 45 deg or steeper, so both halves print
// without support even though the snout is cantilevered off the wall.
module snout(cx, cy, dir, d) {
    d_tip  = d + 3.0;
    root   = 1.5;                       // buried in the wall, welds the snout on
    intersection() {
        translate([cx, cy - dir * root, 0]) rotate([dir > 0 ? -90 : 90, 0, 0])
            cylinder(h = snout_len + root,
                     d1 = d_tip + 2 * (snout_len + root), d2 = d_tip);
        translate([-200, -200, z_bot]) cube([400, 400, z_top - z_bot]);
    }
}

// Bore with three gripping ribs. The ribs are 0.45 mm proud of the bore and
// bite into the cable jacket when the two halves are closed.
module bore(cx, cy, dir, d) {
    total = snout_len + wall + 3;
    translate([cx, cy + dir * snout_len, 0]) rotate([dir > 0 ? -90 : 90, 0, 0])
        difference() {
            union() {
                cylinder(h = total, d = d + 0.3);
                if (sealed)                        // compression grommet seat
                    cylinder(h = grommet_l, d = grommet_d - 0.6);
            }
            if (!sealed)
                for (p = [snout_len + 0.8,
                          snout_len + wall / 2,
                          snout_len + wall - 0.8])
                    translate([0, 0, p])
                        difference() {
                            cylinder(h = 0.9, d = d + 2);
                            translate([0, 0, -eps])
                                cylinder(h = 0.9 + 2 * eps, d = d - 0.6);
                        }
        }
}

module cable_snouts() { for (e = entries) snout(e[0], e[1], e[2], e[3]); }
module cable_bores()  { for (e = entries) bore (e[0], e[1], e[2], e[3]); }

// Cable tie anchor: the tie passes through the slot, around the cable, and
// pulls it down onto the rib. The slot has a 45 deg roof so it self supports.
module tie_rib(cx, cy, d) {
    h_top = -d / 2 - 0.15;
    w = 9; t = 3;
    translate([cx, cy, z_floor_top - eps]) {
        difference() {
            translate([-w / 2, -t / 2, 0])
                cube([w, t, h_top - z_floor_top + eps]);
            translate([0, 0, (h_top - z_floor_top) / 2 - 0.4]) rotate([90, 0, 0])
                linear_extrude(height = t + 2, center = true)
                    polygon([[-2.1, -1.0], [2.1, -1.0], [2.1, 0.4],
                             [0, 2.5], [-2.1, 0.4]]);
        }
    }
}

module tie_ribs() {
    if (tie_slot)
        for (e = entries)
            tie_rib(e[0], e[1] - e[2] * (wall + 2.2), e[3]);
}

// ---------------------------------------------------------------------------
//  Wall openings
// ---------------------------------------------------------------------------
// USB-C (J1). Sized to swallow the moulded boot of a normal USB-C plug, and
// flared on the outside. Straddles the parting line -> no overhang anywhere.
// Profile for an opening that straddles the parting line: rounded at the top,
// square at the bottom. Square sides through the parting line mean the lid lip
// is cut away cleanly, with no sliver of plastic bridging the opening and no
// downward facing ledge in either half. +y is up.
module slot_prof(w, h, r, extra = 0) {
    offset(r = extra) union() {
        rrect(-w / 2, -h / 2, w / 2, h / 2, r);
        translate([-w / 2, -h / 2]) square([w, h / 2]);
    }
}

module usb_prof(extra = 0) { mirror([0, 1, 0]) slot_prof(usb_w, usb_h, 1.6, extra); }

module usb_cut() {
    y_o = y0 - wall - 1;
    if (!hardwire)
        translate([15, 0, usb_z]) rotate([-90, 0, 0]) {
            translate([0, 0, y_o]) linear_extrude(height = wall + 3) usb_prof();
            hull() {                                   // lead-in flare
                translate([0, 0, y_o])
                    linear_extrude(height = eps) usb_prof(1.2);
                translate([0, 0, y_o + 1.6])
                    linear_extrude(height = eps) usb_prof();
            }
        }
}

// IR receiver window (U5) in the left wall.
module ir_cut() {
    depth = sealed ? wall - 0.8 : wall + 3;   // outdoor keeps a 0.8 mm skin
    if (ir_window)
    translate([x0 + 1, 19.5, ir_z]) rotate([0, -90, 0])
        linear_extrude(height = depth + 1)
            rotate([0, 0, -90]) slot_prof(ir_w, ir_h, 1.2);
}

// Status LEDs D2/D3 shine up through the lid roof.
module led_windows() {
    for (p = [[9.2, 58.0], [20.8, 58.0]])
        translate([p[0], p[1], z_ceil - eps])
            cylinder(h = (sealed ? ceil_t - 0.8 : ceil_t + 1) + eps,
                     d = led_win_d);
}

// Openings shared by both halves.
module common_cuts() {
    usb_cut();
    ir_cut();
    cable_bores();
}

// ---------------------------------------------------------------------------
//  Snap fit
// ---------------------------------------------------------------------------
// One finger, in its own frame: the wall inner face is y=0, +y points out.
// The outer face is flat and slides on the floor of the pocket in the base;
// the taper is on the inside, which keeps the bending strain down.
module finger() {
    translate([-fin_w / 2, 0, -fin_h]) {
        hull() {
            translate([0, fin_face - fin_t_tip, 0])
                cube([fin_w, fin_t_tip, 0.1]);
            translate([0, fin_face - fin_t_root, fin_h - 0.1])
                cube([fin_w, fin_t_root, 0.1]);
        }
        // barb: 45 deg lead-in on the way in, flat top face retains.
        // Local -x is +z, so the profile is drawn tip first.
        rotate([0, 90, 0])
            linear_extrude(height = fin_w)
                polygon([[ 0.0,    fin_face],
                         [-0.9,    fin_face + fin_barb],
                         [-barb_h, fin_face + fin_barb],
                         [-barb_h, fin_face]]);
    }
}

module fingers() {
    for (f = fingers)
        translate([f[0], f[1], 0]) rotate([0, 0, f[2]]) finger();
}

// Pocket + catch groove in the base wall for one finger.
module finger_pocket() {
    w = fin_w + 0.5;
    translate([-w / 2, -eps, -fin_h - 0.4])
        cube([w, pocket_t + eps, fin_h + 0.4]);
    translate([-w / 2, -eps, -fin_h - 0.4])
        cube([w, groove_t + eps, barb_h + 0.4 + snap_play]);
}

module finger_pockets() {
    for (f = fingers)
        translate([f[0], f[1], 0]) rotate([0, 0, f[2]]) finger_pocket();
}

// ---------------------------------------------------------------------------
//  Board support
// ---------------------------------------------------------------------------
module standoffs() {
    for (h = holes) translate([h[0], h[1], z_floor_top - eps]) {
        cylinder(h = bot_gap + eps, d = 5.5);
        if (!use_screws)                                    // locating spigot
            translate([0, 0, bot_gap]) cylinder(h = 1.4, d = hole_d - 0.3);
    }
}

module lid_bosses() {
    for (h = holes) translate([h[0], h[1], 0]) cylinder(h = z_ceil, d = 5.5);
}

// M3 countersunk screws. A 90 deg countersink is a 45 deg cone, so it prints
// straight onto the bed with no bridge over the screw head.
module screw_cuts() {
    if (use_screws)
        for (h = holes) translate([h[0], h[1], 0]) {
            translate([0, 0, z_bot - eps])
                cylinder(h = -z_bot + 1, d = 3.4);                  // shank
            translate([0, 0, z_bot - eps])
                cylinder(h = 1.7 + eps, d1 = 6.4, d2 = 3.0);        // countersink
            translate([0, 0, -eps]) cylinder(h = 10, d = 2.5);      // lid pilot
        }
}

// ---------------------------------------------------------------------------
//  Button (SW2 is on the underside of the PCB)
// ---------------------------------------------------------------------------
btn_x    = 15.0;
btn_y    = 31.0;
z_act    = z_pcb_bot - sw_h;             // switch actuator tip
memb_t   = 0.8;
memb_d   = 13.0;
btn_recess_d = 10.0;
btn_recess_h = 1.2;

z_memb = z_bot + memb_t;                  // inside face of the membrane

module button_cuts() {
    // With SW2 not fitted the floor simply stays solid.
    if (button && sealed) {
        // The membrane is printed straight onto the bed - no recess, no
        // bridging - so its outside face comes out smooth and watertight.
        // A shallow engraved ring marks it.
        translate([btn_x, btn_y, z_bot - eps])
            linear_extrude(height = 0.5 + eps)
                difference() {
                    circle(d = memb_d + 2.4);
                    circle(d = memb_d + 1.0);
                }
        // flexible membrane: thin the floor down to memb_t from the inside
        translate([btn_x, btn_y, z_memb])
            cylinder(h = z_floor_top - z_memb + eps, d = memb_d);
        translate([btn_x, btn_y, z_memb - 0.3])              // relief groove
            difference() {
                cylinder(h = 0.3 + eps, d = memb_d - 0.6);
                translate([0, 0, -eps]) cylinder(h = 0.4 + 2 * eps, d = 5.6);
            }
    } else if (button) {
        // Finger dish in the outside face, 45 deg walls so it prints on the
        // bed; the plunger face ends up just below the outside of the case.
        translate([btn_x, btn_y, z_bot - eps])
            cylinder(h = btn_recess_h + eps,
                     d1 = btn_recess_d + 2 * btn_recess_h, d2 = btn_recess_d);
        translate([btn_x, btn_y, z_bot + btn_recess_h - eps])
            cylinder(h = floor_th + 2 * eps, d = 6.3);       // plunger guide
    }
}

module button_adds() {
    if (button && sealed)
        translate([btn_x, btn_y, z_memb - eps])
            cylinder(h = z_act - btn_gap - z_memb + eps, d = 5.0);
}

// Four flat mounting lugs, in the plane of the floor so the bottom of the
// case stays one flat face on the print bed.
module ears() {
    if (use_ears)
        for (e = [[x0 - wall, y0 + 5, -1], [x0 - wall, y1 - 5, -1],
                  [x1 + wall, y0 + 5,  1], [x1 + wall, y1 - 5,  1]])
            translate([0, 0, z_bot]) hull() {
                translate([e[0] + e[2] * (ear_out - ear_w / 2), e[1], 0])
                    cylinder(h = ear_t, d = ear_w);
                translate([e[0] - e[2] * 2, e[1] - ear_w / 2, 0])
                    cube([4, ear_w, ear_t]);
            }
}

module ear_holes() {
    if (use_ears)
        for (e = [[x0 - wall, y0 + 5, -1], [x0 - wall, y1 - 5, -1],
                  [x1 + wall, y0 + 5,  1], [x1 + wall, y1 - 5,  1]])
            translate([e[0] + e[2] * (ear_out - ear_w / 2), e[1], z_bot - eps])
                cylinder(h = ear_t + 2 * eps, d = ear_hole_d);
}

// Captive plunger for the non sealed variants (printed as a third small part).
module plunger() {
    flange_t = 1.2;
    stem = z_floor_top - (z_bot + btn_recess_h - 0.6);   // ends inside the dish
    cylinder(h = flange_t, d = 9.0);                     // captive flange
    translate([0, 0, -stem]) cylinder(h = stem + eps, d = 6.0);
}

module plunger_placed() {
    translate([btn_x, btn_y, z_act - btn_gap - 1.2]) plunger();
}

// ---------------------------------------------------------------------------
//  Feet, gasket, pry notches
// ---------------------------------------------------------------------------
module gasket_groove() {
    if (sealed) {
        w = gasket_d * 1.2;
        d = gasket_d * 0.8;
        translate([0, 0, -d])
            linear_extrude(height = d + eps)
                difference() {
                    offset(r = rebate_t + 0.8 + w) inner2d();
                    offset(r = rebate_t + 0.8) inner2d();
                }
    }
}

module pry_notches() {
    if (!sealed)
        for (p = [[x0 - wall, 30, 90], [x1 + wall, 52, -90]])
            translate([p[0], p[1], 0]) rotate([0, 0, p[2]])
                translate([-6, -1.4, 0]) rotate([0, 90, 0])
                    linear_extrude(height = 12)
                        polygon([[0, 0], [0, 2.0], [-1.4, 2.0]]);
}

// ---------------------------------------------------------------------------
//  The two halves
// ---------------------------------------------------------------------------
module base() {
    difference() {
        union() {
            difference() {                          // shell + inner cavity
                translate([0, 0, z_bot]) linear_extrude(height = -z_bot) outer2d();
                translate([0, 0, z_floor_top])
                    linear_extrude(height = -z_floor_top + eps) inner2d();
            }
            clip_lower() cable_snouts();            // added before the rim is cut
            ears();
            standoffs();
            tie_ribs();
        }
        // continuous rebate for the lid lip, cut as a ring so it cannot eat
        // the stand-offs or the tie ribs
        translate([0, 0, -lip_h - 0.3])
            linear_extrude(height = lip_h + 0.3 + eps)
                difference() {
                    offset(r = rebate_t) inner2d();
                    inner2d();
                }
        finger_pockets();
        gasket_groove();
        common_cuts();
        button_cuts();
        ear_holes();
        screw_cuts();
    }
    button_adds();          // the membrane pillar is added after the cuts
}

module lid() {
    difference() {
        union() {
            difference() {
                linear_extrude(height = z_top) outer2d();
                translate([0, 0, -eps])
                    linear_extrude(height = z_ceil + eps) inner2d();
            }
            // continuous alignment lip
            translate([0, 0, -lip_h])
                linear_extrude(height = lip_h)
                    difference() {
                        offset(r = lip_t) inner2d();
                        inner2d();
                    }
            fingers();
            lid_bosses();
            clip_upper() cable_snouts();
        }
        common_cuts();
        led_windows();
        screw_cuts();
        pry_notches();
    }
}

// ---------------------------------------------------------------------------
//  Mock board, used for the clearance check and the assembly preview
// ---------------------------------------------------------------------------
module part_box(x0_, y0_, x1_, y1_, h, z = 0) {
    translate([x0_, y0_, z]) cube([x1_ - x0_, y1_ - y0_, h]);
}

// The real board keeps a 6 mm disc clear around every mounting hole, which is
// where the stand-offs and the lid bosses land, so the mock does the same.
module hole_keepouts() {
    for (h = holes) translate([h[0], h[1], -20]) cylinder(h = 40, d = 6.0);
}

module pcb_mock() {
    color("#2f7d32") difference() {
        translate([0, 0, -pcb_t]) cube([pcb_w, pcb_l, pcb_t]);
        hole_keepouts();
    }
    color("#9aa0a6") difference() {
        union() {
            part_box(0, 0, pcb_w, pcb_l, 1.5);                 // small SMD parts
            part_box(0, 0, pcb_w, pcb_l, -1.0, -pcb_t);        // solder side
            translate([6.0, 46.0, 0]) cylinder(h = 10.5, d = 10.6);   // C6
            part_box(10.96, 51.95, 19.04, 58.45, 10.4);               // J3
            part_box(10.71, 21.75, 36.21, 39.75, 3.3);            // U1 + antenna
            part_box(10.53,  0.54, 19.47,  7.84, 3.3);                // J1 USB-C
            part_box( 0.93,  8.05,  3.47, 13.13, 8.6);                // J2 header
            if (ir_window)
                part_box(-1.22, 16.98, 3.58, 21.98, 4.0);              // U5 IR
            part_box(11.93, 44.30, 14.93, 48.90, 2.4);                // D1
            part_box(13.40, 12.90, 23.80, 20.30, 2.0);                // U3
            part_box(12.00, 26.75, 18.00, 35.25, -sw_h, -pcb_t);      // SW2
        }
        hole_keepouts();
    }
}

// ---------------------------------------------------------------------------
//  Render
// ---------------------------------------------------------------------------
if (part == "base")          base();
else if (part == "lid")      lid();
else if (part == "plunger")  plunger();
else if (part == "assembly") {
    base();
    color("#7799dd", 0.55) lid();
    pcb_mock();
    if (button && !sealed) color("orange") plunger_placed();
}
else if (part == "exploded") {
    base();
    translate([0, 0, 30]) color("#7799dd") lid();
    translate([0, 0, 12]) pcb_mock();
    if (button && !sealed)
        translate([0, 0, -12]) color("orange") plunger_placed();
}
else if (part == "section") {
    difference() {
        union() {
            base();
            color("#7799dd") lid();
            pcb_mock();
            if (button && !sealed) color("orange") plunger_placed();
        }
        translate([-100, -100, z_bot - 10]) cube([200, 100 + 15, 100]);
    }
}
else if (part == "clashcheck") {
    // Must be empty: any solid here is the lid fouling the base.
    intersection() { base(); lid(); }
}
else if (part == "fitcheck") {
    // Must be empty: any solid here is the case fouling the board.
    intersection() {
        union() { base(); lid(); if (button && !sealed) plunger_placed(); }
        pcb_mock();
    }
}
