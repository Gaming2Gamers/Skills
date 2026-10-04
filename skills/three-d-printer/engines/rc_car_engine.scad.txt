// ====================================================================
// PARAMETRIC MAKER FORGE - RC CAR & VEHICLE COMPONENT ENGINE
// Wheel Hexes, Basher Suspension A-Arms, TPU Bumpers & Spur Gears
// ====================================================================

$fn = 64;

/* [RC Part Selection] */
RC_Part_Type = "WHEEL_HEX_ADAPTER"; // [WHEEL_HEX_ADAPTER:Wheel Hex Hub (Standard/Extended), SUSPENSION_A_ARM:Basher Suspension A-Arm, TPU_BASH_BUMPER:Flexible High-Impact Front Bumper, PINION_SPUR_GEAR:Parametric Drivetrain Gear]

/* [Wheel Hex Hub Settings] */
Hex_Size_Across_Flats = 12.0; // [12.0:12mm (1/10 Scale), 14.0:14mm (Arrma 3S), 17.0:17mm (1/8 Scale)]
Hex_Total_Thickness   = 7.0;  // [4.0:0.5:25.0] Standard is 5-7mm; use 10-25mm for track widener
Axle_Bore_Dia         = 5.05; // 5.0mm for 1/10 Traxxas/Arrma, 4.0mm for Tamiya
Drive_Pin_Slot_Width  = 2.2;  // 2.0mm pin clearance
Drive_Pin_Slot_Depth  = 2.2;
Nut_Recess_Dia        = 9.5;  // M4 wheel nut socket recess
Nut_Recess_Depth      = 2.5;

/* [Suspension A-Arm Settings] */
Arm_Length_Center_Center = 78.0; // Distance between inner and outer hinge pins
Inner_Hinge_Barrel_Width = 38.0;
Outer_Hinge_Barrel_Width = 18.0;
Inner_Hinge_Pin_Dia      = 3.15; // 3.0mm hinge pin clearance
Outer_Hinge_Pin_Dia      = 3.15;
Arm_Truss_Thickness      = 6.5;
Shock_Mount_Positions    = 3;

/* [TPU Bumper Settings] */
Bumper_Width         = 140.0;
Bumper_Depth         = 45.0;
Bumper_Thickness     = 5.0;
Chassis_Mount_Pitch  = 30.0; // Bolt spacing on chassis

/* [Gear Settings] */
Gear_Teeth_Count     = 36;
Gear_Module          = 0.8; // 0.8 Module (32DP) for Traxxas/Axial
Gear_Face_Width      = 6.0;
Motor_Shaft_Dia      = 5.05; // 3.175mm (1/8") or 5.0mm

/* [Part Traceability & Debossing] */
Emboss_RC_Part_ID    = true;
RC_Part_ID_Label     = "12MM-HEX-7MM";

// ====================================================================
// TOP-LEVEL RENDER DISPATCHER
// ====================================================================
if (RC_Part_Type == "WHEEL_HEX_ADAPTER") {
    color([0.2, 0.65, 0.95]) Wheel_Hex_Adapter();
} else if (RC_Part_Type == "SUSPENSION_A_ARM") {
    color([0.85, 0.25, 0.25]) Suspension_A_Arm();
} else if (RC_Part_Type == "TPU_BASH_BUMPER") {
    color([0.15, 0.15, 0.18]) TPU_Bash_Bumper();
} else if (RC_Part_Type == "PINION_SPUR_GEAR") {
    color([0.95, 0.75, 0.2]) Parametric_Gear();
}

// ====================================================================
// MODULE: WHEEL HEX ADAPTER / WIDENER
// ====================================================================
module Wheel_Hex_Adapter() {
    Radius_Circumscribed = (Hex_Size_Across_Flats / 2) / cos(30);

    difference() {
        // Hexagonal prism
        cylinder(r=Radius_Circumscribed, h=Hex_Total_Thickness, $fn=6);

        // Axle bore hole
        translate([0, 0, -1])
            cylinder(d=Axle_Bore_Dia, h=Hex_Total_Thickness + 2);

        // Back drive pin slot (locking onto the cross pin in the axle)
        translate([0, 0, Drive_Pin_Slot_Depth / 2 - 0.01])
            cube([Radius_Circumscribed * 2 + 1, Drive_Pin_Slot_Width, Drive_Pin_Slot_Depth + 0.02], center=true);

        // Front wheel nut socket recess (if widener > 7mm)
        if (Hex_Total_Thickness > 7.0) {
            translate([0, 0, Hex_Total_Thickness - Nut_Recess_Depth + 0.01])
                cylinder(d=Nut_Recess_Dia, h=Nut_Recess_Depth + 1);
        }

        // Debossed size identification on flat
        if (Emboss_RC_Part_ID) {
            translate([0, Hex_Size_Across_Flats / 2 - 0.2, Hex_Total_Thickness / 2])
                rotate([90, 0, 0])
                linear_extrude(0.5)
                text(RC_Part_ID_Label, size=min(2.5, Hex_Total_Thickness * 0.45), halign="center", valign="center", font="Liberation Sans:style=Bold");
        }
    }
}

// ====================================================================
// MODULE: BASHER HIGH-IMPACT SUSPENSION A-ARM
// ====================================================================
module Suspension_A_Arm() {
    difference() {
        union() {
            // Inner chassis hinge barrel
            translate([0, -Inner_Hinge_Barrel_Width / 2, 0])
                rotate([-90, 0, 0])
                cylinder(d=Inner_Hinge_Pin_Dia + 5.0, h=Inner_Hinge_Barrel_Width);

            // Outer hub hinge barrel
            translate([Arm_Length_Center_Center, -Outer_Hinge_Barrel_Width / 2, 0])
                rotate([-90, 0, 0])
                cylinder(d=Outer_Hinge_Pin_Dia + 4.5, h=Outer_Hinge_Barrel_Width);

            // Reinforced triangular truss body
            hull() {
                translate([0, -Inner_Hinge_Barrel_Width / 2 + 2, 0]) sphere(d=Arm_Truss_Thickness);
                translate([0,  Inner_Hinge_Barrel_Width / 2 - 2, 0]) sphere(d=Arm_Truss_Thickness);
                translate([Arm_Length_Center_Center, 0, 0]) sphere(d=Arm_Truss_Thickness);
            }

            // Shock mounting boss
            translate([Arm_Length_Center_Center * 0.58, 0, 0])
                cylinder(d=10, h=Arm_Truss_Thickness * 1.4, center=true);
        }

        // Inner hinge pin hole
        translate([0, -Inner_Hinge_Barrel_Width, 0])
            rotate([-90, 0, 0])
            cylinder(d=Inner_Hinge_Pin_Dia, h=Inner_Hinge_Barrel_Width * 2);

        // Outer hinge pin hole
        translate([Arm_Length_Center_Center, -Outer_Hinge_Barrel_Width, 0])
            rotate([-90, 0, 0])
            cylinder(d=Outer_Hinge_Pin_Dia, h=Outer_Hinge_Barrel_Width * 2);

        // Triangular lightening / flex-relief cutouts
        translate([Arm_Length_Center_Center * 0.28, 0, 0])
            cylinder(d=Inner_Hinge_Barrel_Width * 0.35, h=Arm_Truss_Thickness * 2, center=true);

        // Progressive shock mounting holes (M3 clearance)
        for (i = [0 : Shock_Mount_Positions - 1]) {
            translate([Arm_Length_Center_Center * 0.52 + i * 4.5, 0, 0])
                cylinder(d=3.2, h=Arm_Truss_Thickness * 3, center=true);
        }

        // Debossed label
        if (Emboss_RC_Part_ID) {
            translate([Arm_Length_Center_Center * 0.72, 0, Arm_Truss_Thickness / 2 - 0.4])
                linear_extrude(0.6)
                text("ARM-L", size=2.8, halign="center", valign="center", font="Liberation Sans:style=Bold");
        }
    }
}

// ====================================================================
// MODULE: FLEXIBLE TPU BASH BUMPER
// ====================================================================
module TPU_Bash_Bumper() {
    linear_extrude(Bumper_Thickness) {
        difference() {
            // Aerodynamic & protective curved bumper face
            hull() {
                translate([-Bumper_Width / 2 + 10, Bumper_Depth * 0.7]) circle(r=10);
                translate([ Bumper_Width / 2 - 10, Bumper_Depth * 0.7]) circle(r=10);
                translate([0, Bumper_Depth]) circle(r=15);
                translate([-Chassis_Mount_Pitch / 2 - 8, 0]) square([Chassis_Mount_Pitch + 16, 12]);
            }

            // Energy-absorbing crumple honeycombs
            for (x = [-Bumper_Width / 2 + 25 : 14 : Bumper_Width / 2 - 25]) {
                translate([x, Bumper_Depth * 0.55])
                    circle(r=4.5, $fn=6);
            }

            // Chassis mounting screw holes (M4 or M3 countersunk)
            translate([-Chassis_Mount_Pitch / 2, 6]) circle(d=4.2);
            translate([ Chassis_Mount_Pitch / 2, 6]) circle(d=4.2);
        }
    }
}

// ====================================================================
// MODULE: PARAMETRIC GEAR (SPUR / PINION)
// ====================================================================
module Parametric_Gear() {
    Pitch_D = Gear_Teeth_Count * Gear_Module;
    Tip_D   = Pitch_D + 2 * Gear_Module;
    Root_D  = Pitch_D - 2.5 * Gear_Module;

    difference() {
        union() {
            // Gear rim and teeth
            cylinder(d=Root_D, h=Gear_Face_Width, center=true);
            for (i = [0 : Gear_Teeth_Count - 1]) {
                rotate([0, 0, i * (360 / Gear_Teeth_Count)])
                    translate([Pitch_D / 2, 0, 0])
                    hull() {
                        translate([-Gear_Module * 0.8, -Gear_Module * 0.6, -Gear_Face_Width / 2])
                            cube([Gear_Module * 1.6, Gear_Module * 1.2, Gear_Face_Width]);
                        translate([Gear_Module * 0.8, -Gear_Module * 0.3, -Gear_Face_Width / 2])
                            cube([0.1, Gear_Module * 0.6, Gear_Face_Width]);
                    }
            }
        }

        // Shaft bore
        cylinder(d=Motor_Shaft_Dia, h=Gear_Face_Width + 2, center=true);

        // M3 grub set screw hole into shaft
        translate([0, 0, 0])
            rotate([0, 90, 0])
            cylinder(d=2.9, h=Pitch_D / 2 + 1);
    }
}
