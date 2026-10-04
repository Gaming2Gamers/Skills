// ====================================================================
// PARAMETRIC MAKER FORGE - UNIVERSAL HARDWARE ENCLOSURE ENGINE
// Fully Parametric OpenSCAD with Native Customizer & Part ID Embossing
// ====================================================================

$fn = 48;

/* [What to Generate] */
// Select which part to preview/render
Render_Part = "BOTH_EXPLODED"; // [BOTTOM_BASE:Base Only (Export STL), TOP_LID:Lid Only (Export STL), BOTH_EXPLODED:Both Parts Exploded, BOTH_CLOSED:Both Parts Closed Assembly]

/* [Hardware Device & Part Identification] */
// Stamped Part ID label on chassis floor
Part_ID_Label = "ESP32-DEV-38P";
// Emboss text on bottom of enclosure
Emboss_Part_ID = true;
// Text deboss depth into floor (mm)
Deboss_Depth = 0.6; // [0.2:0.1:1.0]

/* [Internal Enclosure Dimensions] */
Internal_Length = 65.0; // [20:1:300]
Internal_Width  = 38.0; // [20:1:300]
Internal_Height = 22.0; // [10:1:150]
Corner_Radius   = 4.0;  // [1:0.5:15]
Wall_Thickness  = 2.4;  // [1.2:0.2:5.0]
Floor_Thickness = 2.0;  // [1.2:0.2:5.0]

/* [Assembly & Fasteners] */
Fastener_Style = "HEATSET_M3"; // [SNAP_FIT:Snap-Fit Perimeter Lip, HEATSET_M3:M3 Heat-Set Corner Inserts, M3_SCREWS:M3 Direct Thread Screws]
Lid_Split_Ratio = 0.35; // [0.2:0.05:0.8]

/* [Board Mounting Standoffs] */
Enable_Standoffs = true;
Hole_Spacing_X   = 49.5;
Hole_Spacing_Y   = 23.0;
Standoff_Height  = 4.5;
Insert_Pilot_Dia = 4.0;  // 4.0mm for M3 Ruthex, 3.2mm for M2
Standoff_Outer_D = 7.0;

/* [Thermal Ventilation] */
Enable_Vents = true;
Vent_Slot_Width  = 2.5;
Vent_Slot_Length = 18.0;
Vent_Slot_Count  = 5;

// Calculated internal variables
Lid_Height  = Internal_Height * Lid_Split_Ratio;
Base_Height = Internal_Height * (1.0 - Lid_Split_Ratio);
Outer_L = Internal_Length + 2 * Wall_Thickness;
Outer_W = Internal_Width  + 2 * Wall_Thickness;

// Exploded view offset
Explode_Z = (Render_Part == "BOTH_EXPLODED") ? (Base_Height + Lid_Height + 15) : (Render_Part == "BOTH_CLOSED" ? Base_Height : 0);

// ====================================================================
// TOP-LEVEL RENDER DISPATCHER
// ====================================================================
if (Render_Part == "BOTTOM_BASE" || Render_Part == "BOTH_EXPLODED" || Render_Part == "BOTH_CLOSED") {
    color([0.2, 0.5, 0.85, 1.0]) Enclosure_Base();
}

if (Render_Part == "TOP_LID" || Render_Part == "BOTH_EXPLODED" || Render_Part == "BOTH_CLOSED") {
    translate([0, 0, Explode_Z])
    rotate((Render_Part == "TOP_LID") ? [180, 0, 0] : [0, 0, 0])
    color([0.85, 0.85, 0.90, 0.95]) Enclosure_Lid();
}

// ====================================================================
// MODULE: ENCLOSURE BASE
// ====================================================================
module Enclosure_Base() {
    difference() {
        // Outer rounded body
        Rounded_Box(Outer_L, Outer_W, Base_Height + Floor_Thickness, Corner_Radius);

        // Hollow inner cavity
        translate([Wall_Thickness, Wall_Thickness, Floor_Thickness])
            Rounded_Box(Internal_Length, Internal_Width, Base_Height + 2, max(0.5, Corner_Radius - Wall_Thickness));

        // Part ID & Spec debossing on bottom exterior
        if (Emboss_Part_ID) {
            translate([Outer_L / 2, Outer_W / 2, -0.01]) {
                rotate([180, 0, 0])
                linear_extrude(Deboss_Depth) {
                    text(Part_ID_Label, size=3.2, halign="center", valign="center", font="Liberation Sans:style=Bold");
                }
            }
            // Small fastener spec stamp
            translate([Outer_L / 2, 7, -0.01]) {
                rotate([180, 0, 0])
                linear_extrude(Deboss_Depth) {
                    text(str("FASTENER: ", Fastener_Style), size=1.8, halign="center", valign="center");
                }
            }
        }

        // Snap-fit retention groove (if selected)
        if (Fastener_Style == "SNAP_FIT") {
            translate([Wall_Thickness, Wall_Thickness, Base_Height + Floor_Thickness - 1.2])
                difference() {
                    Rounded_Box(Internal_Length, Internal_Width, 1.5, max(0.5, Corner_Radius - Wall_Thickness));
                    translate([0.5, 0.5, -0.5])
                        Rounded_Box(Internal_Length - 1, Internal_Width - 1, 2.5, max(0.5, Corner_Radius - Wall_Thickness));
                }
        }
    }

    // Board Standoff Bosses
    if (Enable_Standoffs) {
        Standoff_X_Offset = (Outer_L - Hole_Spacing_X) / 2;
        Standoff_Y_Offset = (Outer_W - Hole_Spacing_Y) / 2;
        
        translate([Standoff_X_Offset, Standoff_Y_Offset, Floor_Thickness]) Standoff_Boss();
        translate([Standoff_X_Offset + Hole_Spacing_X, Standoff_Y_Offset, Floor_Thickness]) Standoff_Boss();
        translate([Standoff_X_Offset, Standoff_Y_Offset + Hole_Spacing_Y, Floor_Thickness]) Standoff_Boss();
        translate([Standoff_X_Offset + Hole_Spacing_X, Standoff_Y_Offset + Hole_Spacing_Y, Floor_Thickness]) Standoff_Boss();
    }

    // Corner screw bosses (if using heat-sets or screws)
    if (Fastener_Style != "SNAP_FIT") {
        Corner_Boss(Corner_Radius + 1, Corner_Radius + 1);
        Corner_Boss(Outer_L - Corner_Radius - 1, Corner_Radius + 1);
        Corner_Boss(Corner_Radius + 1, Outer_W - Corner_Radius - 1);
        Corner_Boss(Outer_L - Corner_Radius - 1, Outer_W - Corner_Radius - 1);
    }
}

// ====================================================================
// MODULE: ENCLOSURE LID
// ====================================================================
module Enclosure_Lid() {
    difference() {
        union() {
            // Main lid body
            Rounded_Box(Outer_L, Outer_W, Lid_Height + Floor_Thickness, Corner_Radius);

            // Inner interlocking alignment lip / snap-joint ridge
            translate([Wall_Thickness + 0.25, Wall_Thickness + 0.25, -2.5])
                Rounded_Box(Internal_Length - 0.5, Internal_Width - 0.5, 2.5, max(0.5, Corner_Radius - Wall_Thickness));

            // Snap-fit bead on the rim
            if (Fastener_Style == "SNAP_FIT") {
                translate([Wall_Thickness + 0.2, Outer_W / 2 - 8, -1.8])
                    cube([0.5, 16, 0.8]);
                translate([Outer_L - Wall_Thickness - 0.7, Outer_W / 2 - 8, -1.8])
                    cube([0.5, 16, 0.8]);
            }
        }

        // Hollow inner cavity of lid
        translate([Wall_Thickness + 0.5, Wall_Thickness + 0.5, -3])
            Rounded_Box(Internal_Length - 1.0, Internal_Width - 1.0, Lid_Height + 3, max(0.5, Corner_Radius - Wall_Thickness));

        // Thermal ventilation slots
        if (Enable_Vents) {
            Vent_Spacing = Vent_Slot_Width * 2.2;
            Total_Vent_Width = (Vent_Slot_Count - 1) * Vent_Spacing;
            translate([Outer_L / 2 - Total_Vent_Width / 2, Outer_W / 2, Lid_Height + Floor_Thickness - 0.5]) {
                for (i = [0 : Vent_Slot_Count - 1]) {
                    translate([i * Vent_Spacing, 0, -Floor_Thickness - 1])
                        hull() {
                            translate([0, -Vent_Slot_Length / 2, 0]) cylinder(d=Vent_Slot_Width, h=Floor_Thickness + 3);
                            translate([0,  Vent_Slot_Length / 2, 0]) cylinder(d=Vent_Slot_Width, h=Floor_Thickness + 3);
                        }
                }
            }
        }

        // Corner screw counterbore holes (for screws)
        if (Fastener_Style != "SNAP_FIT") {
            Lid_Screw_Hole(Corner_Radius + 1, Corner_Radius + 1);
            Lid_Screw_Hole(Outer_L - Corner_Radius - 1, Corner_Radius + 1);
            Lid_Screw_Hole(Corner_Radius + 1, Outer_W - Corner_Radius - 1);
            Lid_Screw_Hole(Outer_L - Corner_Radius - 1, Outer_W - Corner_Radius - 1);
        }
    }
}

// ====================================================================
// HELPER GEOMETRY PRIMITIVES
// ====================================================================
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
            cylinder(d=7.2, h=Base_Height);
            translate([0, 0, Base_Height - 6.0]) cylinder(d=4.0, h=6.5); // Heat-set pilot
        }
    }
}

module Lid_Screw_Hole(x, y) {
    translate([x, y, -4]) {
        cylinder(d=3.4, h=Lid_Height + Floor_Thickness + 6); // M3 clearance
        translate([0, 0, Lid_Height + Floor_Thickness + 4 - 2.8])
            cylinder(d=6.0, h=4); // M3 SHCS head counterbore
    }
}
