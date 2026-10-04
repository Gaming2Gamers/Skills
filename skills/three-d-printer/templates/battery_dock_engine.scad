// ====================================================================
// PARAMETRIC MAKER FORGE - POWER TOOL & BATTERY DOCK ENGINE
// Wall Mounts & Tool Hangers for Milwaukee M18, DeWalt 20V & Makita 18V
// ====================================================================

$fn = 64;

/* [Tool Ecosystem] */
Battery_System = "MILWAUKEE_M18"; // [MILWAUKEE_M18:Milwaukee M18 RedLithium, DEWALT_20V:DeWalt 20V Max / XR, MAKITA_18V:Makita 18V LXT]

/* [Mount Orientation & Mounting Holes] */
Mount_Type       = "WALL_MOUNT"; // [WALL_MOUNT:Flat Wall / Shelf Underside, BELT_CLIP:Wearable Belt Clip]
Screw_Hole_Dia   = 4.5; // Countersunk #8 or M4 wood screw
Screw_Spacing_X  = 30.0;
Wall_Thickness   = 3.5;

// ====================================================================
// TOP-LEVEL RENDER
// ====================================================================
if (Battery_System == "MILWAUKEE_M18") {
    color([0.85, 0.15, 0.15]) Milwaukee_M18_Dock();
} else if (Battery_System == "DEWALT_20V") {
    color([0.95, 0.80, 0.10]) DeWalt_20V_Dock();
} else if (Battery_System == "MAKITA_18V") {
    color([0.10, 0.65, 0.65]) Makita_18V_Dock();
}

module Milwaukee_M18_Dock() {
    Dock_L = 75.0;
    Rail_W = 44.5;
    Slot_W = 37.0;
    Slot_T = 3.8;
    Lip_T  = 3.2;

    difference() {
        // Main base plate and rails
        union() {
            cube([Rail_W + 2 * Wall_Thickness, Dock_L, 16.0]);
        }

        // Slide cavity
        translate([Wall_Thickness, -1, 16.0 - Slot_T - Lip_T])
            cube([Rail_W, Dock_L + 2, Slot_T + Lip_T + 1]);

        // Inside T-slot overhang lips
        translate([Wall_Thickness + (Rail_W - Slot_W) / 2, -1, 16.0 - Lip_T])
            cube([Slot_W, Dock_L + 2, Lip_T + 1]);

        // Spring latch detent notch
        translate([(Rail_W + 2 * Wall_Thickness) / 2 - 6, 38.5, 16.0 - Lip_T - 2.5])
            cube([12.0, 8.0, 5.0]);

        // Wall mounting screw countersunk holes
        translate([Wall_Thickness + Rail_W / 2 - Screw_Spacing_X / 2, Dock_L * 0.25, -1])
            Countersunk_Screw_Hole();
        translate([Wall_Thickness + Rail_W / 2 + Screw_Spacing_X / 2, Dock_L * 0.25, -1])
            Countersunk_Screw_Hole();
        translate([Wall_Thickness + Rail_W / 2, Dock_L * 0.75, -1])
            Countersunk_Screw_Hole();

        // Stamped brand / system label
        translate([(Rail_W + 2 * Wall_Thickness) / 2, Dock_L / 2, 0.6])
            rotate([180, 0, 0])
            linear_extrude(0.8)
            text("M18 DOCK", size=4.0, halign="center", valign="center", font="Liberation Sans:style=Bold");
    }
}

module DeWalt_20V_Dock() {
    Dock_L = 72.0;
    difference() {
        cube([56.0, Dock_L, 15.0]);

        // DeWalt 45-degree inverted dovetail slide
        translate([28.0, -1, 10.0])
            rotate([-90, 0, 0])
            linear_extrude(Dock_L + 2)
            polygon([
                [-19.0, 0],
                [-21.0, 5.5],
                [ 21.0, 5.5],
                [ 19.0, 0]
            ]);

        // Center latch locking window
        translate([28.0 - 7.5, 28.0, 2.0]) cube([15.0, 8.0, 10.0]);

        // Countersunk screw holes
        translate([12.0, Dock_L / 2, -1]) Countersunk_Screw_Hole();
        translate([44.0, Dock_L / 2, -1]) Countersunk_Screw_Hole();
    }
}

module Makita_18V_Dock() {
    Dock_L = 80.0;
    difference() {
        cube([52.0, Dock_L, 14.0]);

        // Flange tracks
        translate([4.5, -1, 8.0]) cube([43.0, Dock_L + 2, 7.0]);
        translate([9.0, -1, 11.5]) cube([34.0, Dock_L + 2, 4.0]);

        // Screw holes
        translate([26.0, Dock_L * 0.25, -1]) Countersunk_Screw_Hole();
        translate([26.0, Dock_L * 0.75, -1]) Countersunk_Screw_Hole();
    }
}

module Countersunk_Screw_Hole() {
    cylinder(d=Screw_Hole_Dia, h=25);
    cylinder(d1=9.0, d2=Screw_Hole_Dia, h=3.5);
}
