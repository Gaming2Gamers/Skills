// ====================================================================
// PARAMETRIC MAKER FORGE - WORKSHOP JIG & FIXTURE ENGINE
// 90° Clamping Squares, Corner Radius Jigs & Hardened Drill Bushing Guides
// ====================================================================

$fn = 64;

/* [Jig Type] */
Jig_Type = "CORNER_CLAMP_SQUARE"; // [CORNER_CLAMP_SQUARE:90-Degree Clamping Square, RADIUS_ROUTER_JIG:Corner Radius & Chamfer Template, DRILL_BUSHING_BLOCK:Hardened Drill Bushing Guide]

/* [Clamping Square Dimensions] */
Square_Arm_Length = 120.0; // [60:10:250]
Square_Arm_Width  = 30.0;
Square_Thickness  = 18.0;
Clamp_Hole_Dia    = 9.5;   // 3/8" or 10mm clamp hole

/* [Corner Radius Template Settings] */
Corner_Radius_1   = 10.0;  // Radius on Corner 1
Corner_Radius_2   = 20.0;  // Radius on Corner 2
Corner_Radius_3   = 30.0;  // Radius on Corner 3
Corner_Chamfer_4  = 15.0;  // 45-deg Chamfer on Corner 4
Template_Size     = 100.0;

/* [Drill Bushing Guide Settings] */
Drill_Bushing_OD  = 10.0;  // Standard press-fit drill bushing outer diameter
Drill_Bore_Sizes  = [3.0, 4.0, 5.0, 6.0, 8.0, 10.0];
Bushing_Block_H   = 25.0;

// ====================================================================
// TOP-LEVEL RENDER
// ====================================================================
if (Jig_Type == "CORNER_CLAMP_SQUARE") {
    color([0.85, 0.45, 0.15]) Corner_Clamp_Square();
} else if (Jig_Type == "RADIUS_ROUTER_JIG") {
    color([0.25, 0.75, 0.55]) Radius_Router_Jig();
} else if (Jig_Type == "DRILL_BUSHING_BLOCK") {
    color([0.35, 0.45, 0.65]) Drill_Bushing_Block();
}

module Corner_Clamp_Square() {
    difference() {
        // L-shaped solid body
        union() {
            cube([Square_Arm_Length, Square_Arm_Width, Square_Thickness]);
            cube([Square_Arm_Width, Square_Arm_Length, Square_Thickness]);
        }

        // Inside corner stress-relief fillet
        translate([Square_Arm_Width, Square_Arm_Width, -1])
            cylinder(r=4.0, h=Square_Thickness + 2);

        // Standard F-clamp and quick-grip clamp holes
        for (i = [Square_Arm_Width + 20 : 25 : Square_Arm_Length - 15]) {
            translate([i, Square_Arm_Width / 2, -1]) cylinder(d=Clamp_Hole_Dia, h=Square_Thickness + 2);
            translate([Square_Arm_Width / 2, i, -1]) cylinder(d=Clamp_Hole_Dia, h=Square_Thickness + 2);
        }

        // Debossed 90-degree verification label
        translate([Square_Arm_Length * 0.55, Square_Arm_Width / 2, Square_Thickness - 0.6])
            linear_extrude(0.7) text("90° SQUARE", size=3.5, halign="center", valign="center", font="Liberation Sans:style=Bold");
    }
}

module Radius_Router_Jig() {
    T_Thick = 8.0;
    difference() {
        // Main block with 4 distinct radii on 4 corners
        hull() {
            translate([Corner_Radius_1, Corner_Radius_1, 0]) cylinder(r=Corner_Radius_1, h=T_Thick);
            translate([Template_Size - Corner_Radius_2, Corner_Radius_2, 0]) cylinder(r=Corner_Radius_2, h=T_Thick);
            translate([Template_Size - Corner_Radius_3, Template_Size - Corner_Radius_3, 0]) cylinder(r=Corner_Radius_3, h=T_Thick);
            translate([Corner_Chamfer_4, Template_Size - Corner_Chamfer_4, 0]) cylinder(r=Corner_Chamfer_4, h=T_Thick);
        }

        // Center finger grip / clamp cutout
        translate([Template_Size / 2, Template_Size / 2, -1])
            cylinder(d=Template_Size * 0.45, h=T_Thick + 2);

        // Debossed labels for each corner
        translate([16, 16, T_Thick - 0.6]) linear_extrude(0.7) text(str("R", Corner_Radius_1), size=4.0, halign="center");
        translate([Template_Size - 16, 16, T_Thick - 0.6]) linear_extrude(0.7) text(str("R", Corner_Radius_2), size=4.0, halign="center");
        translate([Template_Size - 16, Template_Size - 16, T_Thick - 0.6]) linear_extrude(0.7) text(str("R", Corner_Radius_3), size=4.0, halign="center");
        translate([16, Template_Size - 16, T_Thick - 0.6]) linear_extrude(0.7) text(str("C", Corner_Chamfer_4), size=4.0, halign="center");
    }
}

module Drill_Bushing_Block() {
    Block_L = len(Drill_Bore_Sizes) * 22 + 15;
    difference() {
        cube([Block_L, 35.0, Bushing_Block_H]);

        // Press-fit pockets for hardened steel bushings
        for (i = [0 : len(Drill_Bore_Sizes) - 1]) {
            x = 18 + i * 22;
            translate([x, 17.5, -1]) {
                cylinder(d=Drill_Bore_Sizes[i] + 0.3, h=Bushing_Block_H + 2); // Thru hole
                cylinder(d=Drill_Bushing_OD, h=16.0); // Bushing press-fit pocket
            }
            // Size label
            translate([x, 4.0, Bushing_Block_H - 0.6])
                linear_extrude(0.7) text(str(Drill_Bore_Sizes[i], "mm"), size=3.0, halign="center");
        }

        // Bottom 90° V-groove for self-centering on round pipes and dowels
        translate([-1, 17.5, 0])
            rotate([0, 90, 0])
            rotate([0, 0, 45])
            cube([10, 10, Block_L + 2]);
    }
}
