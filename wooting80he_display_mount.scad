// =====================================================================
//  Wooting 80HE + Waveshare 11.9" HDMI LCD (320x1480) display mount  v9.2
//  https://github.com/yggdrion/wooting-waveshare
//
//  - Two PETG stands. Each holds a glued-in TPU clip pad that snaps into
//    the 80HE foot slots in place of the stock silicone feet.
//  - Slim 3-piece tray case (glued hidden dovetails): the glass sits flush
//    in a rebate on a 0.5 mm ledge, clamped by the display's 25 mm brass
//    standoffs. A back cover presses onto the standoffs over the Pi 4.
//  - Tool-free pivot: flatted axles with 16-sided heads in hidden rails in
//    the stands; slide in from behind with the screen flat, tilt clicks in
//    22.5° steps.
//  - Left stand: USB-C plug tunnel + cable arch.
//
//  Geometry was measured from the official STEP files (not included):
//    - Wooting 80HE: https://github.com/WootingKb/wooting-design (CERN-OHL-S)
//    - Waveshare 11.9inch HDMI LCD: https://www.waveshare.com/wiki/11.9inch_HDMI_LCD
//  kb_rear_profile.scad is a small profile polygon derived from the 80HE
//  case (needed for the stands).
//
//  Optional preview meshes for part="assembly" (not included, see README):
//    wooting80he_case_preview.stl, waveshare_11.9_hdmi_lcd.stl
//  Without them the assembly renders without keyboard/display.
//
//  "K frame" (keyboard frame, mm): X = right, Y = toward the back,
//  Z = up with the switch plate horizontal. Origin = keyboard centre.
//
//  Set `part`, F6, export STL. Printable parts come out print-oriented.
// =====================================================================

/* [What to render] */
part = "assembly"; // [assembly, stand_left, stand_right, stands, pad, pad_left, pad_right, pads, case_mid, case_end_left, case_end_right, case_full, cover]
show_keyboard = false;  // needs wooting80he_case_preview.stl (not included, see README)
show_display  = false;  // needs waveshare_11.9_hdmi_lcd.stl (not included, see README)
show_pi       = true;   // rough Pi 4 envelope for clearance checks
show_cover    = true;

/* [Placement] */
// Recline of the screen from vertical, relative to the desk (deg)
recline = 15;
// Front-bottom edge of the screen case, K frame [Y, Z]. Keyboard rear edge Y=74.4, top case Z=7.5
screen_bottom = [84, 15];
// Stand thickness under the keyboard's rear edge. Smaller = flatter keyboard. 1.0 => ~2.6°
kb_lift = 1.0;

/* [Display (from the Waveshare STEP)] */
glass_l = 287.4;
glass_w = 69.8;
disp_depth = 13.65;     // glass front -> bottom of the M2.5 standoffs
standoffs = [[59.5, 29.25], [-54.5, 29.25], [59.5, -29.85], [-54.5, -29.85]];
// everything below is in the DISPLAY frame (display as in the Waveshare STEP); flip_display rotates it 180°
pi_window = [-46, 52, -34, 33];   // [x0, x1, y0, y1] board + USB/Ethernet block (USB end at +X)
usb_notch = [50, 55.5, -26, 25.5];   // extra window at the USB end for the angled USB adapter board (between the brass standoffs)
conn_box  = [-44, 2, 26, 40.5];   // HDMI adapter + angled USB-C, overhang past the glass edge (+Y)
conn_depth = 5;                   // keep this much solid wall in front of the connectors
flip_display = true;              // true = connector edge at the bottom (toward the keyboard)
chin = 5.5;                       // extra case height on the connector edge
top_rim = chin;                   // extra case height on the opposite (top) edge; = chin -> symmetric case

/* [Back cover (presses onto the 25 mm brass standoffs, optional M2.5 screws)] */
brass_len  = 25;        // brass standoff length (hex part)
brass_af   = 4.8;       // brass hex across flats (measured)
plate_clamp = 1.2;      // tray plate thickness under the brass shoulder (rest of plate_t is a recess)
cover_t    = 2.0;       // cover back plate
cover_grip = 0.15;      // socket undersize on the brass hex corners (0.25 tighter, 0.05 looser)
cover_grip_len = 5;     // how far the sockets slide over the brass standoffs
cover_wall = 1.8;
cover_x    = [-62, 67]; // cover footprint along X (display frame)
port_open  = [-28, 28, 17.5];   // USB/Ethernet opening in the cover end wall: [y0, y1, depth from the cover edge]
pwr_open   = [-42, -16, 21];    // cable notch in the cover's connector-side wall: [x0, x1, depth]
pwr_notch  = false;             // angled USB-C plug -> no notch needed

/* [Case] */
fit_tol  = 0.15;        // glass -> rebate clearance per side
glass_t  = 1.1;         // cover glass thickness (STEP)
ledge    = 0.5;         // the glass rests on this ledge all round (the LCD behind it is smaller)
plate_gap = 0.2;        // display standoffs stop this short of the plate -> brass standoffs pull the glass onto the ledge
wall     = 1.8;
plate_t  = 2.0;
glass_proud = 0.0;
corner_r = 2.5;
m25_clear = 2.8;
m25_head  = 5.2;
split_case = true;
// seams at ±seam_x (symmetric). Must clear the Pi window (52) and the M2.5 heads (62.1)
seam_x   = 65;
dt_clear = 0.12;        // dovetail glue gap

/* [Slide-in mount] */
axle_d    = 10.0;       // axle (neck) diameter
axle_flat = 7.0;        // width across the flats (= neck slot width - clearance)
axle_y    = 0;          // axle position along the screen height (case-local Y, 0 = centre)
head_n    = 16;         // head polygon sides: 16 = 22.5° steps, 12 = 30° (stronger click), 24 = 15° (softer)
head_d    = 16;         // head across corners
head_t    = 3.0;        // head thickness
end_gap   = 5.0;        // case end -> stand (case ends are thickened to close this gap)
wall_in   = 2.4;        // stand wall between case and rail (has the neck slot)
wall_out  = 2.0;        // closed outer wall of the stand
axle_clear = 0.3;       // axial play (each side)
slot_clear = 0.4;       // neck slot width = axle_flat + slot_clear
rail_clear = 0.4;       // head rail clearance
pivot_fit = -0.05;      // head pocket = head + pivot_fit. -0.15 = stiffer, +0.05 = soft clicks
// tilt stop range is free; the flats only line up with the slot when the screen is flat (recline 90°)

/* [Stand + TPU pad] */
kb_clear  = 0.2;
base_back = 120.5;     // stand ends just behind the axle boss (axle Y 108.6 + 11 + 0.9)
base_x_in = 113;
rear_base_t = 5.0;
pad_recess = 0.45;      // depth of the glue recess in the stand (rest = stand floor under the pad)
pad_fit    = 0.25;      // clearance pad <-> recess per side (v9: 0.15 -> 0.25, easier to seat)
// clip (copy of the stock silicone foot clip)
clip_len   = 13.8;      // slot 16.5 with round ends
clip_neck  = 3.5;       // slot 3.7
clip_barb  = 4.3;       // width over the barbs (v9: 4.5 -> 4.3, easier; 4.5 = tighter)
clip_catch = 1.7;       // wall 1.5 + 0.2
clip_release = 0.85;    // height of the barb's back (retention) face: 0.5 = hooks hard, 0.85 = can be pulled off (v9.2), 1.0 = loose
clip_tip   = 3.7;       // total height above the pad

$fn = 48;
usb_bridge = true;      // close the gap in the rear-edge filler over the USB-C plug (plug through a tunnel)
usb_tunnel_top = -7.3;  // tunnel roof (plug top is at -8.33)
include <kb_rear_profile.scad>

// =====================================================================
//  Keyboard data (Wooting STEP, K frame)
// =====================================================================
kb_rear_y = 74.4;
kb_under_half_w = 164.0;
kb_b0 = -13.863;  kb_bs = -0.0489;  // bottom plane Z = kb_b0 + kb_bs*Y
pocket_recess = 1.0;
pocket_x = [116.8, 161.4];          // safe area of the foot pocket (abs X)
pocket_y = [41.2, 60.0];
slot_x   = [119.33, 158.33];
slot_y   = 49.75;
front_pad = [-59.2, -12.6];
usb_x = [-148.8, -136.7];

function kb_bottom(y) = kb_b0 + kb_bs*y;
floor_ang = atan(-kb_bs);
lift_pt  = [68, kb_bottom(68) - kb_clear - kb_lift];
desk_ang = atan((front_pad[1]-lift_pt[1])/(lift_pt[0]-front_pad[0]));
function desk(y) = lift_pt[1] - tan(desk_ang)*(y-lift_pt[0]);

// =====================================================================
//  Case
// =====================================================================
case_l = glass_l + 2*fit_tol + 2*wall;
case_w = glass_w + 2*fit_tol + 2*wall;
case_d = disp_depth + plate_gap + plate_t - glass_proud;
yb_d = -(case_w/2 + top_rim);  yt_d = case_w/2 + chin;   // outline in the display frame (chin on +Y)
y_bot = flip_display ? -yt_d : yb_d;                 // bottom edge, case-local
brass_top = disp_depth + plate_gap + plate_clamp + brass_len;    // depth of the brass standoff tops
cover_depth = brass_top + cover_t;                   // total depth glass front -> cover back

phi = 90 - recline - desk_ang;
function rx(v,a) = [v[0], v[1]*cos(a)-v[2]*sin(a), v[1]*sin(a)+v[2]*cos(a)];
corner_rel = rx([0, y_bot, case_d/2], phi);
pivot = [0, screen_bottom[0]-corner_rel[1], screen_bottom[1]-corner_rel[2]];
function L2K(y,z) = let(v = rx([0,y,z+case_d/2], phi)) [pivot[1]+v[1], pivot[2]+v[2]];   // case-local (y,z) -> K (Y,Z)
upright_in = case_l/2 + end_gap;
upright_t = wall_in + head_t + rail_clear + wall_out;
case_lo = 2*(upright_in - axle_clear);     // outer case length incl. thickened ends
axle_z = -case_d + axle_flat/2;            // axle centre, case-local Z (flat sits on the back face)
axle_K = L2K(axle_y, axle_z);              // axle centre in K (Y,Z)
head_x0 = upright_in + wall_in + rail_clear/2;   // head inner face, K X

echo(str("CASE  ", case_lo, " x ", yt_d-yb_d, " x ", case_d, " mm  (+ cover to ", cover_depth, " mm)"));
echo(str("KEYBOARD TILT ", desk_ang, "°"));
echo(str("PIECES  end ", head_x0+head_t-seam_x, " mm   mid ", 2*seam_x+10, " mm   cover ", cover_x[1]-cover_x[0], " x ", yt_d-yb_d, " x ", cover_depth-case_d, " mm"));
assert(upright_in > -usb_x[0]+1.5, "stands would hit the USB cable");
assert(seam_x > max(abs(pi_window[0]),abs(pi_window[1]))+3, "seam cuts the Pi window");
assert(seam_x > max([for (p=standoffs) abs(p[0])]) + 5, "seam too close to the standoffs");
assert(seam_x > max(abs(cover_x[0]), abs(cover_x[1])) - 3 || true, "");

module rbox(s, r) { hull() for (x=[-1,1], y=[-1,1]) translate([x*(s[0]/2-r), y*(s[1]/2-r), 0]) cylinder(r=r, h=s[2]); }
module place_case() { translate(pivot) rotate([phi,0,0]) translate([0,0,case_d/2]) children(); }

// 2D shapes in the case-local (y,z) plane, centred on the axle
module flat_circle(d) intersection() { circle(d=d); square([d+1, axle_flat], center=true); }
module head2d(grow=0) {   // rounded polygon
    offset(r=1) offset(delta=-1+grow) circle(d=head_d, $fn=head_n);
}
module xext(x0, len) translate([x0, axle_y, axle_z]) rotate([90,0,90]) linear_extrude(len) children();   // extrude along +X at the axle
module axle() {   // +X end
    x_case = case_lo/2 - 0.5;
    xext(x_case, head_x0 - x_case + head_t/2) flat_circle(axle_d);
    // head, cut flat at the back face so it prints on the bed
    intersection() {
        xext(head_x0, head_t) head2d();
        translate([head_x0-1, -100, -case_d]) cube([head_t+2, 200, 100]);
    }
}
module disp_frame() rotate([0,0,flip_display?180:0]) children();   // display frame -> case-local

// tray in the display frame: X along, Y up (connector edge +Y), front edge Z=0, back face Z=-case_d
module tray_d() {
    difference() {
        translate([0,(yb_d+yt_d)/2,-case_d]) rbox([case_lo, yt_d-yb_d, case_d], corner_r);
        // glass rebate (flush with the front) + narrower cavity behind it -> the glass sits on a ledge all round
        translate([0,0,-glass_t+glass_proud]) rbox([glass_l+2*fit_tol, glass_w+2*fit_tol, case_d], 1);
        translate([0,0,-(case_d-plate_t)]) rbox([glass_l-2*ledge, glass_w-2*ledge, case_d], 1);
        // Pi window
        translate([(pi_window[0]+pi_window[1])/2, (pi_window[2]+pi_window[3])/2, -case_d-1]) rbox([pi_window[1]-pi_window[0], pi_window[3]-pi_window[2], plate_t+2], 3);
        // notch for the USB adapter board at the USB/Ethernet end
        translate([(usb_notch[0]+usb_notch[1])/2, (usb_notch[2]+usb_notch[3])/2, -case_d-1]) rbox([usb_notch[1]-usb_notch[0], usb_notch[3]-usb_notch[2], plate_t+2], 1.5);
        // connector cavity (HDMI adapter + angled USB-C), closed in front
        translate([(conn_box[0]+conn_box[1])/2, (conn_box[2]+conn_box[3])/2, -case_d-1]) rbox([conn_box[1]-conn_box[0], conn_box[3]-conn_box[2], case_d+1-conn_depth], 1.5);
        // brass standoffs: M2.5 thread through, hex shoulder sits in a shallow recess
        for (p=standoffs) translate([p[0], p[1], -case_d-1]) {
            cylinder(d=m25_clear, h=plate_t+2);
            cylinder(d=brass_af/cos(30)+0.4, h=1+plate_t-plate_clamp, $fn=48);   // round, so the hex can stop at any angle
        }
    }
}
module case_body() {
    disp_frame() tray_d();
    for (s=[-1,1]) scale([s,1,1]) axle();
}

// back cover in the display frame (front edge sits on the tray back at Z=-case_d)
module cover_d() {
    L = cover_x[1]-cover_x[0]; W = yt_d-yb_d; H = cover_depth-case_d; xc = (cover_x[0]+cover_x[1])/2; yc = (yb_d+yt_d)/2;
    boss_h = cover_grip_len + 1;
    difference() {
        union() {
            difference() {
                translate([xc, yc, -cover_depth]) rbox([L, W, H], corner_r);
                translate([xc, yc, -brass_top]) rbox([L-2*cover_wall, W-2*cover_wall, H], max(0.5, corner_r-cover_wall));
            }
            for (p=standoffs) translate([p[0], p[1], -brass_top]) cylinder(d=brass_af/cos(30)+4.4, h=boss_h);
        }
        for (p=standoffs) translate([p[0], p[1], 0]) {
            translate([0,0,-cover_depth-1]) cylinder(d=m25_clear, h=cover_t+2);                 // screw
            translate([0,0,-brass_top-0.01]) cylinder(d=brass_af/cos(30)-cover_grip, h=boss_h+1, $fn=48);   // press-fit socket: grips the hex corners at any angle
        }
        // USB/Ethernet opening in the +X end wall, open to the front edge
        translate([cover_x[1]-cover_wall-1, port_open[0], -case_d-port_open[2]]) cube([cover_wall+2, port_open[1]-port_open[0], port_open[2]+1]);
        // cable notch in the connector-side wall
        if (pwr_notch) translate([pwr_open[0], yt_d-cover_wall-1, -case_d-pwr_open[2]]) cube([pwr_open[1]-pwr_open[0], cover_wall+2, pwr_open[2]+1]);
        // vents over the SoC
        for (i=[-4:4]) translate([6+i*5, -2, -cover_depth-1]) hull() for (y=[-16,16]) translate([0,y,0]) cylinder(d=2.2, h=cover_t+2, $fn=16);
    }
}
module cover() disp_frame() cover_d();

// dovetail seam at X = sx (2D), returns the region of the MID piece side; tails stick outward
// seam look: 0 = joints visible on the front (v7.1), 1 = blind joints (straight hairline on the front),
//            2 = blind joints + a V-groove "reveal" around the case at each seam
seam_style = 2;
front_skin = 1.2;      // style 1/2: the wall joints stop this far behind the front face (groove 0.6 + 0.6 skin)
groove_w   = 1.2;      // style 2: groove width at the surface (90° V, depth = half the width)

module seam_base2d(sx, grow=0) {   // straight seam + back-plate dovetails
    n = 3; y0 = -case_w/2 + 4; pitch = (case_w-8)/n; s = sign(sx);
    translate([s>0 ? sx-1000 : sx, -500]) square([1000, 1000]);
    for (i=[0:n-1]) translate([sx, y0+pitch*(i+0.5)]) scale([s,1])
        offset(delta=grow) polygon([[-1,-3],[-1,3],[5,4.5],[5,-4.5]]);
}
module seam_wall2d(sx, grow=0) {   // side-wall joints, owned by the END piece and reaching into the mid piece
    s = sign(sx); y_in = glass_w/2 - ledge; fl = flip_display ? -1 : 1;
    // identical dovetail in both long walls, centred in the wall thickness (chin = display +Y, top rim = display -Y)
    for (yc = [fl*((y_in + case_w/2 + chin)/2), -fl*((y_in + case_w/2 + top_rim)/2)])
        translate([sx, yc]) scale([s,1]) offset(delta=grow) polygon([[1,-1.7],[1,1.7],[-7,2.6],[-7,-2.6]]);
}
module seam2d(sx, grow=0) { seam_base2d(sx, grow); }   // (kept for reference)
module seam_region(sx, grow=0) {   // 3D region that belongs to the MID side of the seam at sx
    z_top = seam_style>=1 ? -front_skin : 101;      // wall joints stop behind the front skin (skin stays on the mid piece)
    difference() {
        translate([0,0,-101]) linear_extrude(202) seam_base2d(sx, grow);
        translate([0,0,-102]) linear_extrude(102+z_top) seam_wall2d(sx, -grow);
    }
}
// decorative grooves: same look as the real seams, at the same pitch (0, ±seam_x, ±2·seam_x ...)
fake_seams = true;
side_grooves = true;      // fake joint at mid-height of the left/right frame bars
side_groove_y = 0;        // its height (case-local Y, 0 = centre)
side_groove_len = 5;      // how far it wraps onto the end face (axle starts 8.85 mm behind the front)
groove_xs = fake_seams ? [for (i=[-floor((case_lo/2-12)/seam_x):floor((case_lo/2-12)/seam_x)]) i*seam_x] : [-seam_x, seam_x];
module seam_grooves() {
    w = groove_w; d = groove_w/2;
    y_hi = flip_display ? -yb_d : yt_d;      // outer faces, case-local
    y_lo = flip_display ? -yt_d : yb_d;
    for (gx = groove_xs) translate([gx, 0, 0]) {
        rotate([90,0,0]) linear_extrude(300, center=true) polygon([[-w/2,0.01],[w/2,0.01],[0,-d]]);              // front face
        translate([0, y_hi, -100]) linear_extrude(200) polygon([[-w/2,0.01],[w/2,0.01],[0,-d]]);                  // top outer face
        translate([0, y_lo, -100]) linear_extrude(200) polygon([[-w/2,-0.01],[w/2,-0.01],[0,d]]);                 // chin outer face
        // back face (skipped where the cover hides it)
        if (abs(gx) >= seam_x-0.01 || gx < -cover_x[1] || gx > -cover_x[0])
            translate([0, 0, -case_d]) rotate([-90,0,0]) linear_extrude(300, center=true) polygon([[-w/2,0.01],[w/2,0.01],[0,-d]]);
    }
    // fake joint across the left/right frame bars at mid-height (front face), wrapping onto the end face
    // and stopping above the axle (the rest of the end face is hidden by the stand anyway)
    if (side_grooves) for (sg=[-1,1]) {
        translate([sg>0 ? glass_l/2 - 2 : -case_lo/2 - 1, side_groove_y, 0]) rotate([0,90,0])
            linear_extrude(case_lo/2 - glass_l/2 + 3) polygon([[-0.01,-w/2],[-0.01,w/2],[d,0]]);
        translate([sg*case_lo/2, side_groove_y, -side_groove_len]) linear_extrude(side_groove_len+0.01)
            polygon([[sg*0.01,-w/2],[sg*0.01,w/2],[-sg*d,0]]);
    }
}

// wall splints, glued against the inside of the long walls across each seam
// on the mid piece; assemble front edge DOWN and lower the end pieces from above
splint_len = 16;      // reach across the seam
splint_t   = 3.0;     // thickness (away from the wall)
splint_h   = 2.8;     // height above the back plate (stays behind the LCD module, which ends 10.8 mm deep)
module splints(owner="mid") {
    y_in = glass_w/2 - ledge; g = dt_clear/2; z0 = -(case_d-plate_t);
    for (sx=[-1,1], sy=[-1,1]) scale([sx,1,1]) {
        if (owner=="mid") hull() {
            translate([seam_x-2, sy>0 ? y_in-splint_t : -y_in, z0-0.01]) cube([2-g, splint_t+0.01, splint_h+0.01]);
            translate([seam_x+g, sy>0 ? y_in-splint_t : -y_in+g, z0+g]) cube([splint_len-g, splint_t-g, splint_h-g]);
        } else hull() {
            translate([seam_x+g, sy>0 ? y_in-splint_t : -y_in, z0-0.01]) cube([2-g, splint_t+0.01, splint_h+0.01]);
            translate([seam_x-splint_len, sy>0 ? y_in-splint_t : -y_in+g, z0+g]) cube([splint_len-g, splint_t-g, splint_h-g]);
        }
    }
}
module case_mid() {
    difference() {
        union() {
            intersection() { case_body(); intersection() { seam_region(seam_x, -dt_clear/2); seam_region(-seam_x, -dt_clear/2); } }
            splints("mid");
        }
        if (seam_style==2) seam_grooves();
    }
}
module case_end(s) {   // s = +1 right end (local +X), -1 left end
    difference() {
        union() {
            difference() {
                intersection() { case_body(); translate([s>0 ? 0 : -1000, -500, -100]) cube([1000,1000,200]); }
                seam_region(s*seam_x, dt_clear/2);
            }
        }
        if (seam_style==2) seam_grooves();
    }
}

// =====================================================================
//  Stand (K frame, right side; left = mirror)
// =====================================================================
// ramp on the rear underside of the stands so they slide up onto a mouse pad instead of catching on its edge.
// sled_round = false: 45° bevel (prints cleanly desk-face down, no supports)
// sled_round = true : smooth radius-sled_r curve (slides nicer, but its shallow start overhangs -> supports from build plate)
sled_round = false;
sled_h = 3;           // how far the rear bottom edge is lifted
sled_r = 20;
module sled_cut(y_end, x0, x1) {
    L = sled_round ? sqrt(sled_r*sled_r - (sled_r-sled_h)*(sled_r-sled_h)) : sled_h;
    translate([x0, y_end, desk(y_end)]) rotate([-desk_ang,0,0]) rotate([90,0,90]) linear_extrude(x1-x0)
        if (sled_round) difference() { translate([-L, -5]) square([L+1, sled_h+5]); translate([-L, sled_r]) circle(r=sled_r, $fn=180); }
        else polygon([[-L-0.01,-5],[1,-5],[1,sled_h+1],[0,sled_h],[-L,0],[-L-0.01,0]]);
}
module halfspace_above_desk(off=0) { translate([0,lift_pt[0],lift_pt[1]+off/cos(desk_ang)]) rotate([-desk_ang,0,0]) translate([-500,-500,0]) cube([1000,1000,300]); }
module below_kb_bottom(off) { translate([0,0,kb_b0-off]) rotate([-floor_ang,0,0]) translate([-500,-500,-300]) cube([1000,1000,300]); }
// keyboard-bottom frame: XY like K, Z = height above the keyboard's bottom plane
module kbf() { translate([0,0,kb_b0]) rotate([-floor_ang,0,0]) children(); }

// pad centred on the two clips -> it is 180°-symmetric (either way round is correct) and left = right
pad_c  = [(slot_x[0]+slot_x[1])/2, slot_y];
pad_sz = [2*(min(pad_c[0]-pocket_x[0], pocket_x[1]-pad_c[0]) - 0.3), 2*(min(pad_c[1]-pocket_y[0], pocket_y[1]-pad_c[1]) - 0.3)];   // top, inside the pocket
pad_top = pocket_recess - 0.1;
// tapered pad body (in kbf). grow = extra size per side
pad_bot = -kb_clear - pad_recess;   // flat glue face of the pad (kbf)
module pad_block(grow=0, extra_up=0) {
    translate([pad_c[0], pad_c[1], pad_bot]) rbox([pad_sz[0]+2*grow, pad_sz[1]+2*grow, pad_top-pad_bot+extra_up], 2.5+grow);
}
module clip2d() {   // solid TPU clip: neck through the wall, barb, ramp to the tip
    polygon([[-clip_neck/2, -0.5], [clip_neck/2, -0.5],
             [clip_neck/2, clip_catch], [clip_barb/2, clip_catch+clip_release], [clip_barb/2, clip_catch+clip_release+0.1],
             [1.0, clip_tip], [-1.0, clip_tip],
             [-clip_barb/2, clip_catch+clip_release+0.1], [-clip_barb/2, clip_catch+clip_release], [-clip_neck/2, clip_catch]]);
}
module clip3d() {   // chamfered ends so it starts easily
    intersection() {
        rotate([90,0,0]) linear_extrude(height=clip_len, center=true) clip2d();
        hull() {
            translate([-5,-clip_len/2,-1]) cube([10, clip_len, 1+clip_catch]);
            translate([-5,-clip_len/2+1.5,-1]) cube([10, clip_len-3, 1+clip_tip]);
        }
    }
}
module pad_local() {   // pad in the keyboard-bottom frame
    pad_block(0);
    for (x=slot_x) translate([x, slot_y, pad_top]) clip3d();
}
module pad_right() kbf() pad_local();   // TPU, K frame
module pad_left() mirror([1,0,0]) pad_right();

module stand_right() {
    x_out = upright_in + upright_t;
    difference() {
        union() {
            // thin plate under the keyboard
            intersection() {
                halfspace_above_desk();
                below_kb_bottom(kb_clear);
                translate([base_x_in, pocket_y[0]-7, -60]) cube([kb_under_half_w-base_x_in, 72-pocket_y[0]+7, 80]);
            }
            // thicker base behind the keyboard
            intersection() {
                halfspace_above_desk();
                difference() { translate([base_x_in, 72, -60]) cube([x_out-base_x_in, base_back-72, 80]); halfspace_above_desk(rear_base_t); }
            }
            // filler that hugs the keyboard's rear edge (no gap; keyboard can still be lowered onto the clips)
            intersection() {
                halfspace_above_desk();
                translate([base_x_in, 0, 0]) rotate([90,0,90]) linear_extrude(x_out-base_x_in) polygon(kb_rear_profile);
            }
            // upright around the axle
            intersection() {
                halfspace_above_desk();
                translate([upright_in, 0, 0]) rotate([90,0,90]) linear_extrude(upright_t)
                    hull() {
                        translate(axle_K) circle(r=head_d/2+3);
                        translate([kb_rear_profile[len(kb_rear_profile)-2][0] - 1, kb_rear_profile[len(kb_rear_profile)-2][1] - 1]) square(1);   // reach down to the back-top corner of the rear-edge filler (no notch between them)
                        translate([kb_rear_y+1.5, desk(kb_rear_y)-5]) square([base_back-kb_rear_y-1.5, 1]);
                    }
            }
        }
        // sled ramp at the back edge
        sled_cut(base_back, base_x_in-1, x_out+1);
        // shallow glue recess for the TPU pad (closed floor underneath)
        kbf() pad_block(pad_fit, 5);
        // inner wall: round seat for the neck + neck slot to the back (flats horizontal = screen flat)
        translate([upright_in-1, 0, 0]) rotate([90,0,90]) linear_extrude(1+wall_in+rail_clear/2+0.01) translate(axle_K) {
            circle(d=axle_d + 0.3);
            rotate(-desk_ang) translate([0, -(axle_flat+slot_clear)/2]) square([100, axle_flat+slot_clear]);
        }
        // hidden rail for the head + detent pocket (outer wall stays closed; the C-shaped hook springs open for the clicks)
        translate([head_x0-rail_clear/2, 0, 0]) rotate([90,0,90]) linear_extrude(head_t+rail_clear) translate(axle_K) {
            rotate(phi) head2d(pivot_fit);                                   // pocket = head at the design angle
            rotate(-desk_ang) translate([0, -axle_flat/2-rail_clear/2]) square([100, axle_flat/2+head_d/2+rail_clear]);   // rail (head flat side down when the screen lies face up)
        }
        // channel for the USB-C plug (left side; mirrored on the right too).
        // usb_bridge: the rear-edge filler bridges over the plug (tunnel), open channel only behind it
        if (usb_bridge) {
            translate([-usb_x[0]-1-12.5, 60, -15.6]) cube([12.5+2, 85-60, usb_tunnel_top+15.6]);
            translate([-usb_x[0]-1-12.5, 85-0.01, -15.6]) cube([12.5+2, 15, 50]);   // short: further back the base top is already below the plug
        } else translate([-usb_x[0]-1-12.5, 60, -15.6]) cube([12.5+2, 100, 50]);
    }
}
// cable guide on the LEFT stand (K frame): two rigid L-hooks one behind the other, opening to opposite sides,
// on the normal rear base behind the keyboard's USB-C plug (plug + strain relief end at Y 140.5).
// The cable goes under the front hook from the inside and under the rear hook from the outside; nothing flexes.
// cable guide on the LEFT stand (v9): a solid arch at the back edge, in line with the plug tunnel.
// Nothing sticks out to snap off: the outer wall is the upright, the inner wall and roof are 3.5 / 3 mm.
// Thread the keyboard end of the cable through the arch, then through the tunnel, then plug it in.
guide_len   = 8;                    // arch length along the cable
guide_open  = [-usb_x[0]-1-12.5, -usb_x[0]+1];   // opening across (right-stand X; same as the plug tunnel)
guide_h     = 9;                    // opening height above the base (the plug is 6.6 mm tall)
guide_wall  = 3.5;                  // inner wall
guide_roof  = 3;
module on_base(y) translate([0, y, desk(y) + rear_base_t/cos(desk_ang)]) rotate([-desk_ang,0,0]) children();
module cable_guide() {   // left stand, K frame
    x0 = -guide_open[1]; x1 = -guide_open[0];          // opening in left-stand X (x0 < x1)
    on_base(base_back - 1 - guide_len) rotate([90,0,0]) mirror([0,0,1]) linear_extrude(guide_len)
        difference() {
            let(xa = -upright_in - 1, xb = x1 + guide_wall, h = guide_h + guide_roof)
                polygon([[xa, -1], [xb, -1], [xb, h - 1.5], [xb - 1.5, h], [xa, h]]);   // chamfered inner top edge
            translate([x0, 0]) square([x1 - x0, guide_h]);
        }
}
module stand_left() { mirror([1,0,0]) stand_right(); cable_guide(); }

// =====================================================================
//  Previews
// =====================================================================
module display_model() {
    rotate([0,0,flip_display?180:0]) translate([0,0,-2.6+glass_proud]) multmatrix([[-1,0,0,0],[0,0,1,0],[0,1,0,0],[0,0,0,1]])
        import("waveshare_11.9_hdmi_lcd.stl");
}
module pi_model() disp_frame() {   // Pi 4 on the inner standoffs + adapters + brass standoffs (display frame)
    zb = -disp_depth;   // board front face
    translate([-41.9, -29.95, zb-1.5]) cube([85, 56, 1.5]);
    translate([24, -26.5, zb-1.5-16]) cube([22.5, 53.5, 16]);       // USB / Ethernet
    translate([-38, 17, zb-1.5-9]) cube([52, 6, 9]);                // GPIO header
    translate([-28, 26, zb-1.5-6]) cube([26, 13.9, disp_depth+1.5+6-6]);  // HDMI adapter (display port -> Pi micro-HDMI)
    translate([-37, 26, zb-1.5-15]) cube([12, 13.9, 15]);           // angled USB-C plug
    color("Gold") for (p=standoffs) translate([p[0], p[1], -brass_top]) cylinder(d=brass_af/cos(30), h=brass_len, $fn=6);
}

// print orientation: desk face down
module to_print(xc, yc) {
    translate([0, -yc + lift_pt[0], 0]) rotate([desk_ang,0,0]) translate([-xc, -lift_pt[0], -lift_pt[1]]) children();
}
module print_stand(side) {
    xc = (upright_in + upright_t + base_x_in)/2; yc = (base_back+pocket_y[0])/2;
    if (side>0) to_print(xc, yc) stand_right(); else mirror([1,0,0]) to_print(xc, yc) mirror([1,0,0]) stand_left();
}
module print_pad(side) {   // glue face down
    module p() translate([-pad_c[0], -pad_c[1], -pad_bot]) pad_local();
    if (side>0) p(); else mirror([1,0,0]) p();
}
module print_cover() translate([0,0,cover_depth]) rotate([0,0,0]) cover_d();   // back plate down, open side up
module print_case(which) {   // back plate down
    translate([0,0,case_d])
    if (which=="full") case_body();
    else if (which=="mid") case_mid();
    else if (which=="end_r") translate([-(case_lo/2+seam_x)/2,0,0]) case_end(1);
    else translate([(case_lo/2+seam_x)/2,0,0]) case_end(-1);
}

if (part=="assembly") {
    if (show_keyboard) color("Gainsboro", 0.55) import("wooting80he_case_preview.stl");
    color("SteelBlue") { stand_right(); stand_left(); }
    color("OrangeRed") { pad_right(); pad_left(); }
    place_case() {
        color("DimGray") case_body();
        if (show_display) color("Black") display_model();
        if (show_pi) color("ForestGreen") pi_model();
        if (show_cover) color("SlateGray", 0.9) cover();
    }
    color("Tan", 0.3) translate([0,lift_pt[0],lift_pt[1]]) rotate([-desk_ang,0,0]) translate([-220,-160,-2]) cube([440,280,2]);
}
if (part=="stand_right") print_stand(1);
if (part=="stand_left")  print_stand(-1);
if (part=="stands") { translate([-35,0,0]) print_stand(1); translate([35,0,0]) print_stand(-1); }
if (part=="pad") print_pad(1);   // both pads are identical
if (part=="pad_right") print_pad(1);
if (part=="pad_left")  print_pad(-1);
if (part=="pads") { translate([0,-15,0]) print_pad(1); translate([0,15,0]) print_pad(-1); }
if (part=="case_full") print_case("full");
if (part=="case_mid")  print_case("mid");
if (part=="case_end_right") print_case("end_r");
if (part=="case_end_left")  print_case("end_l");
if (part=="cover") print_cover();
// checks
if (part=="dbg_stand_K") stand_right();
if (part=="dbg_pad_K") pad_right();
if (part=="dbg_case_K") place_case() { case_body(); cover(); pi_model(); }
if (part=="dbg_pi_K") place_case() pi_model();
if (part=="dbg_disp_local") display_model();
if (part=="dbg_case_local") case_body();
if (part=="dbg_parts_local") { case_mid(); case_end(1); case_end(-1); }
if (part=="dbg_mid_local") case_mid();
if (part=="dbg_endr_local") case_end(1);
if (part=="dbg_endl_local") case_end(-1);
if (part=="dbg_floor") echo(str("FLOOR under pad (min/max): ", kb_bottom(pocket_y[0])-kb_clear-pad_recess-desk(pocket_y[0]), " / ", kb_bottom(pocket_y[1])-kb_clear-pad_recess-desk(pocket_y[1])));
// tilt check: case rotated about the axle by dtilt degrees more recline
dtilt = 0;
if (part=="dbg_case_tilt") translate([0,axle_K[0],axle_K[1]]) rotate([-dtilt,0,0]) translate([0,-axle_K[0],-axle_K[1]]) place_case() { case_body(); pi_model(); cover(); }
if (part=="dbg_cover_local") cover();
if (part=="dbg_pi_local") pi_model();
if (part=="dbg_cover_K") place_case() cover();
if (part=="dbg_stand_both") { stand_right(); stand_left(); }
if (part=="dbg_standl_K") stand_left();
if (part=="dbg_guide_K") cable_guide();
dslide = 0;   // insertion check: case at recline 90 moved back along the rail
if (part=="dbg_case_insert") translate([0, cos(desk_ang)*dslide, -sin(desk_ang)*dslide]) translate([0,axle_K[0],axle_K[1]]) rotate([-(90-recline),0,0]) translate([0,-axle_K[0],-axle_K[1]]) place_case() { case_body(); cover(); pi_model(); }
// section through one brass standoff: tray + display + brass + cover (display frame)
if (part=="dbg_standoff_section") intersection() {
    union() { color("DimGray") tray_d(); color("SlateGray") cover_d(); color("Gold") pi_model_brass(); color("Black") display_model_d(); }
    translate([standoffs[0][0]-0.01, -60, -60]) cube([0.02+40, 120, 70]);
}
module pi_model_brass() for (p=standoffs) translate([p[0], p[1], -brass_top]) cylinder(d=brass_af/cos(30), h=brass_len, $fn=6);
module display_model_d() translate([0,0,-2.6+glass_proud]) multmatrix([[-1,0,0,0],[0,0,1,0],[0,1,0,0],[0,0,0,1]]) import("waveshare_11.9_hdmi_lcd.stl");
