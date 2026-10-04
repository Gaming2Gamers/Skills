// ====================================================================
// PARAMETRIC MAKER FORGE - UNIVERSAL ENCLOSURE ENGINE
// Snap-Fit, Heat-Set, Magnetic, Vented, & Multi-Color / AMS-Ready
// ====================================================================

$fn = 48;

/* [What to Generate] */
Render_Part = "BOTH_EXPLODED"; // [BOTTOM_BASE:Base Only, TOP_LID:Lid Only, BOTH_EXPLODED:Both Parts Exploded, BOTH_CLOSED:Both Parts Closed Assembly, AMS_ACCENT_TEXT:AMS Multi-Color Text Inset Only]

/* [Hardware Device & Part Identification] */
Part_ID_Label    = "RPI-5-B";
Emboss_Part_ID   = true;
Deboss_Depth     = 0.6; // [0.2:0.1:1.0]

/* [Enclosure Dimensions] */
Internal_Length  = 92.0;  // [20:1:350]
Internal_Width   = 62.0;  // [20:1:350]
Internal_Height  = 28.0;  // [10:1:200]
Corner_Radius    = 4.5;   // [1:0.5:15]
Wall_Thickness   = 2.4;   // [1.2:0.2:6.0]
Floor_Thickness  = 2.0;   // [1.2:0.2:6.0]

/* [Fasteners & Lid Retention] */
Fastener_Style   = "HEATSET_M3"; // [SNAP_FIT:Snap-Fit Perimeter Lip, HEATSET_M3:M3 Heat-Set Corner Inserts, MAGNET_6x3:6x3mm Neodymium Corner Magnets, M3_SCREWS:M3 Direct Thread Screws]
Lid_Split_Ratio  = 0.35; // [0.2:0.05:0.8]

/* [Thermal Ventilation] */
Enable_Vents     = true;
Vent_Style       = "HEX_HONEYCOMB"; // [HEX_HONEYCOMB:Hexagonal Honeycomb Mesh, SLOTTED_GRILL:Parallel Ventilation Slots]
Vent_Mesh_Size   = 5.0;

/* [Board Standoffs] */
Enable_Standoffs = true;
Hole_Spacing_X   = 58.0; // RPi 5 standard
Hole_Spacing_Y   = 49.0;
Standoff_Height  = 4.5;
Insert_Pilot_Dia = 4.0;  // 4.0mm for M3 Ruthex
Standoff_Outer_D = 7.2;

// Calculated variables
Lid_Height  = Internal_Height * Lid_Split_Ratio;
Base_Height = Internal_Height * (1.0 - Lid_Split_Ratio);
Outer_L     = Internal_Length + 2 * Wall_Thickness;
Outer_W     = Internal_Width  + 2 * Wall_Thickness;
Explode_Z   = (Render_Part == "BOTH_EXPLODED") ? (Base_Height + Lid_Height + 20) : (Render_Part == "BOTH_CLOSED" ? Base_Height : 0);

// ====================================================================
// TOP-LEVEL RENDER DISPATCHER
// ====================================================================
if (Render_Part == "BOTTOM_BASE" || Render_Part == "BOTH_EXPLODED" || Render_Part == "BOTH_CLOSED") {
    color([0.2, 0.55, 0.90, 1.0]) Enclosure_Base();
}

if (Render_Part == "TOP_LID" || Render_Part == "BOTH_EXPLODED" || Render_Part == "BOTH_CLOSED") {
    translate([0, 0, Explode_Z])
    rotate((Render_Part == "TOP_LID") ? [180, 0, 0] : [0, 0, 0])
    color([0.90, 0.90, 0.94, 0.95]) Enclosure_Lid();
}

if (Render_Part == "AMS_ACCENT_TEXT") {
    color([1.0, 0.85, 0.1]) AMS_Text_Inset();
}

// ====================================================================
// MODULE: BASE
// ====================================================================
module Enclosure_Base() {
    difference() {
        Rounded_Box(Outer_L, Outer_W, Base_Height + Floor_Thickness, Corner_Radius);

        // Hollow interior cavity
        translate([Wall_Thickness, Wall_Thickness, Floor_Thickness])
            Rounded_Box(Internal_Length, Internal_Width, Base_Height + 2, max(0.5, Corner_Radius - Wall_Thickness));

        // Stamped Part ID debossing
        if (Emboss_Part_ID) {
            translate([Outer_L / 2, Outer_W / 2, -0.01])
                rotate([180, 0, 0])
                linear_extrude(Deboss_Depth)
                text(Part_ID_Label, size=3.4, halign="center", valign="center", font="Liberation Sans:style=Bold");

            translate([Outer_L / 2, 7.5, -0.01])
                rotate([180, 0, 0])
                linear_extrude(Deboss_Depth)
                text(str("MOUNT: ", Fastener_Style), size=2.0, halign="center", valign="center");
        }

        // Snap-fit lip groove
        if (Fastener_Style == "SNAP_FIT") {
            translate([Wall_Thickness, Wall_Thickness, Base_Height + Floor_Thickness - 1.2])
                difference() {
                    Rounded_Box(Internal_Length, Internal_Width, 1.5, max(0.5, Corner_Radius - Wall_Thickness));
                    translate([0.5, 0.5, -0.5])
                        Rounded_Box(Internal_Length - 1, Internal_Width - 1, 2.5, max(0.5, Corner_Radius - Wall_Thickness));
                }
        }
    }

    // Board Standoffs
    if (Enable_Standoffs) {
        Standoff_X_Offset = (Outer_L - Hole_Spacing_X) / 2;
        Standoff_Y_Offset = (Outer_W - Hole_Spacing_Y) / 2;
        translate([Standoff_X_Offset, Standoff_Y_Offset, Floor_Thickness]) Standoff_Boss();
        translate([Standoff_X_Offset + Hole_Spacing_X, Standoff_Y_Offset, Floor_Thickness]) Standoff_Boss();
        translate([Standoff_X_Offset, Standoff_Y_Offset + Hole_Spacing_Y, Floor_Thickness]) Standoff_Boss();
        translate([Standoff_X_Offset + Hole_Spacing_X, Standoff_Y_Offset + Hole_Spacing_Y, Floor_Thickness]) Standoff_Boss();
    }

    // Corner Bosses (Heat-Sets or Magnets)
    if (Fastener_Style != "SNAP_FIT") {
        Corner_Boss(Corner_Radius + 1.2, Corner_Radius + 1.2);
        Corner_Boss(Outer_L - Corner_Radius - 1.2, Corner_Radius + 1.2);
        Corner_Boss(Corner_Radius + 1.2, Outer_W - Corner_Radius - 1.2);
        Corner_Boss(Outer_L - Corner_Radius - 1.2, Outer_W - Corner_Radius - 1.2);
    }
}

// ====================================================================
// MODULE: LID
// ====================================================================
module Enclosure_Lid() {
    difference() {
        union() {
            Rounded_Box(Outer_L, Outer_W, Lid_Height + Floor_Thickness, Corner_Radius);

            // Alignment lip
            translate([Wall_Thickness + 0.25, Wall_Thickness + 0.25, -2.5])
                Rounded_Box(Internal_Length - 0.5, Internal_Width - 0.5, 2.5, max(0.5, Corner_Radius - Wall_Thickness));

            if (Fastener_Style == "SNAP_FIT") {
                translate([Wall_Thickness + 0.2, Outer_W / 2 - 10, -1.8]) cube([0.5, 20, 0.8]);
                translate([Outer_L - Wall_Thickness - 0.7, Outer_W / 2 - 10, -1.8]) cube([0.5, 20, 0.8]);
            }
        }

        // Hollow interior
        translate([Wall_Thickness + 0.5, Wall_Thickness + 0.5, -3])
            Rounded_Box(Internal_Length - 1.0, Internal_Width - 1.0, Lid_Height + 3, max(0.5, Corner_Radius - Wall_Thickness));

        // Ventilation mesh
        if (Enable_Vents) {
            if (Vent_Style == "HEX_HONEYCOMB") {
                intersection() {
                    translate([Outer_L / 2, Outer_W / 2, Lid_Height + Floor_Thickness - 1])
                        cube([Internal_Length * 0.7, Internal_Width * 0.65, Floor_Thickness * 3], center=true);
                    for (x = [15 : Vent_Mesh_Size * 1.5 : Outer_L - 15]) {
                        for (y = [15 : Vent_Mesh_Size * 1.73 : Outer_W - 15]) {
                            translate([x, y, -2]) cylinder(d=Vent_Mesh_Size, h=Lid_Height + Floor_Thickness + 4, $fn=6);
                            translate([x + Vent_Mesh_Size * 0.75, y + Vent_Mesh_Size * 0.866, -2]) cylinder(d=Vent_Mesh_Size, h=Lid_Height + Floor_Thickness + 4, $fn=6);
                        }
                    }
                }
            } else {
                for (x = [Outer_L / 2 - 25 : 6 : Outer_L / 2 + 25]) {
                    translate([x, Outer_W / 2, -2])
                        hull() {
                            translate([0, -12, 0]) cylinder(d=2.5, h=Lid_Height + Floor_Thickness + 4);
                            translate([0,  12, 0]) cylinder(d=2.5, h=Lid_Height + Floor_Thickness + 4);
                        }
                }
            }
        }

        // Corner screw / magnet holes
        if (Fastener_Style == "HEATSET_M3" || Fastener_Style == "M3_SCREWS") {
            Lid_Screw_Hole(Corner_Radius + 1.2, Corner_Radius + 1.2);
            Lid_Screw_Hole(Outer_L - Corner_Radius - 1.2, Corner_Radius + 1.2);
            Lid_Screw_Hole(Corner_Radius + 1.2, Outer_W - Corner_Radius - 1.2);
            Lid_Screw_Hole(Outer_L - Corner_Radius - 1.2, Outer_W - Corner_Radius - 1.2);
        } else if (Fastener_Style == "MAGNET_6x3") {
            Lid_Magnet_Pocket(Corner_Radius + 1.2, Corner_Radius + 1.2);
            Lid_Magnet_Pocket(Outer_L - Corner_Radius - 1.2, Corner_Radius + 1.2);
            Lid_Magnet_Pocket(Corner_Radius + 1.2, Outer_W - Corner_Radius - 1.2);
            Lid_Magnet_Pocket(Outer_L - Corner_Radius - 1.2, Outer_W - Corner_Radius - 1.2);
        }
    }
}

module AMS_Text_Inset() {
    translate([Outer_L / 2, Outer_W / 2, 0])
        rotate([180, 0, 0])
        linear_extrude(Deboss_Depth)
        text(Part_ID_Label, size=3.4, halign="center", valign="center", font="Liberation Sans:style=Bold");
}

module Rounded_Box(length, width, height, radius) {
    r = min(radius, length / 2 - 0.1, width / 2 - 0.1);
    hull() {
        translate([r, r, 0]) cylinder(r=r, h=height);
        translate([length - r, r, 0]) cylinder(r=r, h=height);
        translate([length - r, width - r, 0]) cylinder(r=r, h=height);
        translate([r, width - r, 0]) cylinder(r=r, h=height);
    }
}

module Standoff_Boss() {
    difference() {
        cylinder(d=Standoff_Outer_D, h=Standoff_Height);
        translate([0, 0, -0.5]) cylinder(d=Insert_Pilot_Dia, h=Standoff_Height + 1);
    }
}

module Corner_Boss(x, y) {
    translate([x, y, Floor_Thickness]) {
        difference() {
            cylinder(d=7.4, h=Base_Height);
            if (Fastener_Style == "HEATSET_M3") {
                translate([0, 0, Base_Height - 6.0]) cylinder(d=4.0, h=6.5);
            } else if (Fastener_Style == "MAGNET_6x3") {
                translate([0, 0, Base_Height - 3.2]) cylinder(d=6.2, h=3.5);
            } else {
                cylinder(d=2.8, h=Base_Height + 1);
            }
        }
    }
}

module Lid_Screw_Hole(x, y) {
    translate([x, y, -4]) {
        cylinder(d=3.4, h=Lid_Height + Floor_Thickness + 6);
        translate([0, 0, Lid_Height + Floor_Thickness + 4 - 2.8])
            cylinder(d=6.0, h=4);
    }
}

module Lid_Magnet_Pocket(x, y) {
    translate([x, y, -0.1]) cylinder(d=6.2, h=3.2);
}
