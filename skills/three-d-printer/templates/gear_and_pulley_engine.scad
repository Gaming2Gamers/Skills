// ====================================================================
// PARAMETRIC MAKER FORGE - GEAR & PULLEY TRANSMISSION ENGINE
// GT2 Timing Pulleys & Self-Centering Double-Helical Herringbone Gears
// ====================================================================

$fn = 72;

/* [Transmission Type] */
Drive_Type      = "GT2_TIMING_PULLEY"; // [GT2_TIMING_PULLEY:GT2 2mm Timing Belt Pulley, HERRINGBONE_GEAR:Double-Helical Herringbone Spur Gear, STANDARD_SPUR:Standard Involute Spur Gear]

/* [GT2 Pulley Settings] */
GT2_Teeth_Count = 20;   // [16:1:120]
Belt_Width      = 6.0;  // 6mm or 9mm belt
Flange_Height   = 1.4;
Motor_Shaft_Dia = 5.05; // 5.0mm for NEMA 17, 8.0mm for lead screw
Hub_Height      = 6.0;
Hub_Outer_Dia   = 16.0;

/* [Herringbone Gear Settings] */
Gear_Module     = 1.0;  // [0.5:0.1:2.5]
Gear_Teeth      = 32;   // [10:1:100]
Helix_Angle     = 30.0; // 30-degree herringbone angle
Face_Width      = 12.0;

// GT2 constants
GT2_Pitch = 2.0;
Pitch_Dia = (GT2_Teeth_Count * GT2_Pitch) / 3.14159265;
Out_Dia   = Pitch_Dia - 2 * 0.254;

// ====================================================================
// TOP-LEVEL RENDER
// ====================================================================
if (Drive_Type == "GT2_TIMING_PULLEY") {
    color([0.85, 0.85, 0.88]) GT2_Pulley();
} else if (Drive_Type == "HERRINGBONE_GEAR") {
    color([0.25, 0.75, 0.45]) Herringbone_Gear();
}

module GT2_Pulley() {
    difference() {
        union() {
            // Lower retaining flange
            cylinder(d=Out_Dia + 4.0, h=Flange_Height);

            // Toothed belt track
            translate([0, 0, Flange_Height]) {
                cylinder(d=Out_Dia - 0.76, h=Belt_Width + 1.0);
                for (i = [0 : GT2_Teeth_Count - 1]) {
                    rotate([0, 0, i * (360 / GT2_Teeth_Count)])
                        translate([Out_Dia / 2 - 0.4, 0, 0])
                        cylinder(d=1.0, h=Belt_Width + 1.0);
                }
            }

            // Upper retaining flange
            translate([0, 0, Flange_Height + Belt_Width + 1.0])
                cylinder(d=Out_Dia + 4.0, h=Flange_Height);

            // Motor shaft clamping hub
            translate([0, 0, 2 * Flange_Height + Belt_Width + 1.0])
                cylinder(d=Hub_Outer_Dia, h=Hub_Height);
        }

        // Shaft bore hole
        translate([0, 0, -1])
            cylinder(d=Motor_Shaft_Dia, h=2 * Flange_Height + Belt_Width + Hub_Height + 4);

        // M3 grub set-screw hole in hub
        translate([0, 0, 2 * Flange_Height + Belt_Width + 1.0 + Hub_Height / 2])
            rotate([0, 90, 0])
            cylinder(d=2.9, h=Hub_Outer_Dia + 1);
    }
}

module Herringbone_Gear() {
    P_Dia = Gear_Teeth * Gear_Module;
    O_Dia = P_Dia + 2 * Gear_Module;
    R_Dia = P_Dia - 2.5 * Gear_Module;

    difference() {
        union() {
            // Lower helical half
            linear_extrude(height=Face_Width / 2, twist=Helix_Angle, convexity=10)
                Gear_2D_Profile(P_Dia, O_Dia, R_Dia, Gear_Teeth, Gear_Module);

            // Upper inverted helical half (Herringbone apex)
            translate([0, 0, Face_Width / 2])
                linear_extrude(height=Face_Width / 2, twist=-Helix_Angle, convexity=10)
                rotate([0, 0, Helix_Angle])
                Gear_2D_Profile(P_Dia, O_Dia, R_Dia, Gear_Teeth, Gear_Module);
        }

        // Shaft bore
        translate([0, 0, -1])
            cylinder(d=Motor_Shaft_Dia, h=Face_Width + 2);

        // Keyway / D-cut
        translate([Motor_Shaft_Dia / 2 - 0.5, -1.0, -1])
            cube([2.0, 2.0, Face_Width + 2]);
    }
}

module Gear_2D_Profile(pd, od, rd, teeth, m) {
    union() {
        circle(d=rd);
        for (i = [0 : teeth - 1]) {
            rotate([0, 0, i * (360 / teeth)])
                translate([pd / 2, 0])
                polygon([
                    [-m * 0.8, -m * 0.7],
                    [ m * 1.0, -m * 0.3],
                    [ m * 1.0,  m * 0.3],
                    [-m * 0.8,  m * 0.7]
                ]);
        }
    }
}
