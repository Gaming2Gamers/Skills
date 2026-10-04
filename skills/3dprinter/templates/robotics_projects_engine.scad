// ====================================================================
// PARAMETRIC MAKER FORGE - ROBOTICS PROJECTS & EMBODIED KITS ENGINE
// Autonomous Rover, Pan-Tilt Head, OpenArm Joints & Kids STEM Amazon Kit
// Built with ∞ Meraki - From $15 Amazon Kid Builds to Pro 7-DOF Arms
// ====================================================================

$fn = 64;

/* [Robotics Project Selection] */
Robotics_Project = "KIDS_STEM_ARM_LINK"; // [KIDS_STEM_ARM_LINK:Kids STEM Mini-Arm Link (Amazon SG90/MG90S), AUTONOMOUS_ROVER:Autonomous Mobile Base (Yellow TT Motors / LiDAR), PAN_TILT_HEAD:2-DOF Pan-Tilt Expressive Neck, OPENARM_JOINT:Pro 7-DOF Kinematic Arm Joint, PARALLEL_GRIPPER:Parallel Robotic Gripper, COMPANION_POD:Desktop AI Companion Pod]

/* [Actuator Hardware Tier] */
Actuator_Hardware_Tier = "AMAZON_BUDGET_SG90"; // [AMAZON_BUDGET_SG90:Cheap Amazon 9g Servos (SG90 / MG90S - $1.50 each), AMAZON_MG996R:Amazon Standard Servos (MG996R / MG995 - $6 each), PRO_ACTUATOR_CAN:Pro Brushless / CAN Actuators (DaMiao / SteadyWin)]

/* [Kids STEM Mini-Arm Settings (SG90)] */
STEM_Arm_Length      = 85.0; // [50:5:140] Length between joints
STEM_Servo_Horn_Type = "CROSS_HORN"; // [CROSS_HORN:Standard White 4-Point Cross, SINGLE_ARM:Single Arm Lever, ROUND_DISC:Small Circular Disc]

/* [Rover Chassis Settings] */
Rover_Length        = 180.0;
Rover_Width         = 140.0;
Deck_Thickness      = 4.0;
Lidar_Tower_Height  = 55.0;

/* [∞ Meraki Hallmark & Part Traceability] */
Emboss_Meraki_Hallmark = true;
Emboss_Project_ID      = true;
Project_Part_Label     = "KIDS-ARM-LINK-SG90";

// ====================================================================
// TOP-LEVEL RENDER DISPATCHER
// ====================================================================
if (Robotics_Project == "KIDS_STEM_ARM_LINK") {
    color([0.25, 0.75, 0.85]) Kids_STEM_Mini_Arm_Link();
} else if (Robotics_Project == "AUTONOMOUS_ROVER") {
    color([0.18, 0.22, 0.28]) Rover_Chassis_Deck();
    translate([0, 0, Lidar_Tower_Height]) color([0.85, 0.25, 0.25]) Elevated_Lidar_Tower();
} else if (Robotics_Project == "PAN_TILT_HEAD") {
    color([0.25, 0.55, 0.85]) Pan_Tilt_Head_Assembly();
} else if (Robotics_Project == "OPENARM_JOINT") {
    color([0.22, 0.65, 0.85]) OpenArm_Kinematic_Link();
} else if (Robotics_Project == "PARALLEL_GRIPPER") {
    color([0.85, 0.45, 0.15]) Parallel_Gripper_Assembly();
} else if (Robotics_Project == "COMPANION_POD") {
    color([0.90, 0.90, 0.95]) Desktop_Companion_Pod();
}

// ====================================================================
// MODULE: BESPOKE ∞ MERAKI HALLMARK
// ====================================================================
module Meraki_Hallmark(size=3.5, depth=0.6) {
    linear_extrude(depth) {
        text("∞ MERAKI", size=size, halign="center", valign="center", font="Liberation Sans:style=Bold");
    }
}

// ====================================================================
// MODULE: KIDS STEM MINI-ARM LINK (OPTIMIZED FOR $1.50 AMAZON SG90)
// ====================================================================
module Kids_STEM_Mini_Arm_Link() {
    Link_W = 20.0;
    Link_T = 16.0;

    difference() {
        union() {
            // Joint 1 Servo Mount Block (Housing the SG90)
            translate([0, 0, 0])
                Rounded_Box(28.0, 32.0, Link_T, 4.0);

            // Bicep/Forearm Structural Connecting Beam
            translate([14.0, 6.0, 0])
                cube([STEM_Arm_Length - 28.0, Link_W, Link_T]);

            // Joint 2 Horn Capture Hub (Driven by next SG90 horn)
            translate([STEM_Arm_Length, 16.0, 0])
                cylinder(d=26.0, h=Link_T);
        }

        // Pocket 1: Cheap Amazon SG90 / MG90S Pocket
        // SG90 body: 22.8 x 12.2 x 22.8mm
        translate([2.5, 9.8, -1.0])
            cube([23.2, 12.5, Link_T + 2]);

        // SG90 Wire exit slit
        translate([-1.0, 13.5, 2.0])
            cube([6.0, 5.0, Link_T]);

        // SG90 M2 Flange mounting screw pilot holes
        translate([14.0, 2.0, -1]) cylinder(d=1.8, h=Link_T + 2);
        translate([14.0, 30.0, -1]) cylinder(d=1.8, h=Link_T + 2);

        // Pocket 2: Standard Cheap White Nylon Servo Horn Pocket on Joint 2
        translate([STEM_Arm_Length, 16.0, Link_T - 2.5])
            Servo_Horn_Capture_Pocket(STEM_Servo_Horn_Type);

        // Center Horn Retention Screw Hole (M2.5 screw into servo output shaft)
        translate([STEM_Arm_Length, 16.0, -1.0])
            cylinder(d=2.6, h=Link_T + 2);

        // Weight reduction cutouts
        translate([STEM_Arm_Length * 0.45, 16.0, -1])
            cylinder(d=10.0, h=Link_T + 2);
        translate([STEM_Arm_Length * 0.65, 16.0, -1])
            cylinder(d=10.0, h=Link_T + 2);

        // Stamped Labels & ∞ Meraki Hallmark
        if (Emboss_Project_ID) {
            translate([STEM_Arm_Length * 0.55, 16.0, Link_T - 0.5])
                rotate([0, 0, 0])
                linear_extrude(0.6)
                text("SG90-ARM", size=2.5, halign="center", valign="center", font="Liberation Sans:style=Bold");
        }
        if (Emboss_Meraki_Hallmark) {
            translate([STEM_Arm_Length * 0.55, 16.0, 0.5])
                rotate([180, 0, 0])
                Meraki_Hallmark(size=2.4, depth=0.6);
        }
    }
}

// Module for pressing in the free white nylon horns that come with Amazon servos
module Servo_Horn_Capture_Pocket(type) {
    if (type == "CROSS_HORN") {
        // 4-point cross horn (typical 18mm x 18mm span, 1.6mm thickness)
        cube([19.5, 4.2, 3.0], center=true);
        cube([4.2, 19.5, 3.0], center=true);
        cylinder(d=7.8, h=3.0, center=true);
    } else if (type == "SINGLE_ARM") {
        // Single lever horn
        translate([6.0, 0, 0]) cube([16.0, 4.5, 3.0], center=true);
        cylinder(d=7.8, h=3.0, center=true);
    } else {
        // Round horn disc
        cylinder(d=20.5, h=3.0, center=true);
    }
}

// ====================================================================
// MODULE: AUTONOMOUS ROVER (YELLOW TT MOTORS + RPLIDAR)
// ====================================================================
module Rover_Chassis_Deck() {
    difference() {
        hull() {
            translate([15, 15, 0]) cylinder(r=15, h=Deck_Thickness);
            translate([Rover_Length - 15, 15, 0]) cylinder(r=15, h=Deck_Thickness);
            translate([Rover_Length - 15, Rover_Width - 15, 0]) cylinder(r=15, h=Deck_Thickness);
            translate([15, Rover_Width - 15, 0]) cylinder(r=15, h=Deck_Thickness);
        }

        // Amazon Yellow TT Dual-Shaft Motor Mounting Holes (M3 thru-holes)
        // TT motor standard: 2x 3mm holes spaced 17.5mm apart
        translate([Rover_Length * 0.35, 12.0, -1]) {
            cylinder(d=3.2, h=Deck_Thickness + 2);
            translate([17.5, 0, 0]) cylinder(d=3.2, h=Deck_Thickness + 2);
        }
        translate([Rover_Length * 0.35, Rover_Width - 12.0, -1]) {
            cylinder(d=3.2, h=Deck_Thickness + 2);
            translate([17.5, 0, 0]) cylinder(d=3.2, h=Deck_Thickness + 2);
        }

        // Wheel cutouts
        translate([Rover_Length * 0.35 - 5, -1, -1]) cube([45.0, 16.0, Deck_Thickness + 2]);
        translate([Rover_Length * 0.35 - 5, Rover_Width - 15.0, -1]) cube([45.0, 16.0, Deck_Thickness + 2]);

        // Caster wheel rear socket
        translate([Rover_Length - 30.0, Rover_Width / 2, -1]) cylinder(d=28.0, h=Deck_Thickness + 2);

        // Arduino Uno / Nano / L298N standoff holes
        for (x = [40 : 25 : Rover_Length - 40]) {
            for (y = [30 : 25 : Rover_Width - 30]) {
                translate([x, y, -1]) cylinder(d=3.2, h=Deck_Thickness + 2);
            }
        }

        if (Emboss_Meraki_Hallmark) {
            translate([Rover_Length / 2, Rover_Width * 0.8, Deck_Thickness - 0.6])
                Meraki_Hallmark(size=3.5, depth=0.7);
        }
    }
}

module Elevated_Lidar_Tower() {
    translate([Rover_Length * 0.25, Rover_Width / 2, 0]) {
        difference() {
            union() {
                cylinder(d=68.0, h=4.0);
                for (a = [0, 120, 240]) {
                    rotate([0, 0, a]) translate([26.0, 0, -Lidar_Tower_Height]) cylinder(d=8.0, h=Lidar_Tower_Height);
                }
            }
            translate([ 20.0,  20.0, -1]) cylinder(d=2.7, h=6.0);
            translate([-20.0,  20.0, -1]) cylinder(d=2.7, h=6.0);
            translate([ 20.0, -20.0, -1]) cylinder(d=2.7, h=6.0);
            translate([-20.0, -20.0, -1]) cylinder(d=2.7, h=6.0);
            cylinder(d=20.0, h=6.0);
        }
    }
}

// ====================================================================
// MODULE: OPENARM PRO 7-DOF KINEMATIC JOINT LINK
// ====================================================================
module OpenArm_Kinematic_Link() {
    Link_L = 140.0;
    difference() {
        union() {
            cylinder(d=58.0, h=32.0, center=true);
            translate([Link_L / 2, 0, 0]) rotate([0, 90, 0]) cylinder(d=36.0, h=Link_L, center=true);
            translate([Link_L, 0, 0]) cylinder(d=52.0, h=28.0, center=true);
        }
        cylinder(d=22.0, h=40.0, center=true);
        for (a = [0 : 60 : 300]) {
            rotate([0, 0, a]) translate([22.0, 0, -20]) cylinder(d=3.2, h=40.0);
        }
        translate([Link_L, 0, 0]) {
            cylinder(d=16.0, h=40.0, center=true);
            for (a = [0 : 90 : 270]) {
                rotate([0, 0, a]) translate([18.0, 0, -20]) cylinder(d=3.2, h=40.0);
            }
        }
        translate([Link_L / 2, 0, 0]) rotate([0, 90, 0]) cylinder(d=14.0, h=Link_L + 20, center=true);
        if (Emboss_Meraki_Hallmark) {
            translate([Link_L / 2, 17.5, 0]) rotate([90, 0, 0]) Meraki_Hallmark(size=3.2, depth=0.7);
        }
    }
}

// ====================================================================
// MODULE: 2-DOF PAN-TILT NECK ASSEMBLY
// ====================================================================
module Pan_Tilt_Head_Assembly() {
    difference() {
        union() {
            cylinder(d=72.0, h=10.0);
            translate([0, 0, 10.0]) cylinder(d=64.0, h=25.0);
        }
        translate([0, 0, 12.0]) cube([20.2, 41.2, 40.0], center=true);
        translate([0, 0, 28.0]) cylinder(d=22.15, h=8.0);
        for (a = [0 : 90 : 270]) {
            rotate([0, 0, a]) translate([31.5, 0, -1]) cylinder(d=3.4, h=12.0);
        }
        if (Emboss_Meraki_Hallmark) {
            translate([0, 24.0, 9.4]) Meraki_Hallmark(size=2.8, depth=0.7);
        }
    }

    translate([0, 0, 52.0]) {
        difference() {
            union() {
                translate([0, 0, -5.0]) cube([48.0, 52.0, 6.0], center=true);
                translate([-21.0, 0, 15.0]) cube([6.0, 52.0, 40.0], center=true);
                translate([ 21.0, 0, 15.0]) cube([6.0, 52.0, 40.0], center=true);
            }
            translate([21.0, 0, 18.0]) cube([8.0, 23.2, 12.5], center=true);
            translate([-21.0, 0, 18.0]) rotate([0, 90, 0]) cylinder(d=6.0, h=10.0, center=true);
        }
        translate([0, 18.0, 18.0]) {
            difference() {
                cube([92.0, 6.0, 28.0], center=true);
                translate([-22.5, 0, 0]) rotate([90, 0, 0]) cylinder(d=3.2, h=10.0, center=true);
                translate([ 22.5, 0, 0]) rotate([90, 0, 0]) cylinder(d=3.2, h=10.0, center=true);
                cube([65.0, 10.0, 18.0], center=true);
            }
        }
    }
}

// ====================================================================
// MODULE: ROBOTIC PARALLEL GRIPPER
// ====================================================================
module Parallel_Gripper_Assembly() {
    difference() {
        cube([65.0, 45.0, 28.0], center=true);
        cube([41.0, 20.5, 32.0], center=true);
        translate([0,  16.0, 0]) rotate([0, 90, 0]) cylinder(d=3.15, h=70.0, center=true);
        translate([0, -16.0, 0]) rotate([0, 90, 0]) cylinder(d=3.15, h=70.0, center=true);
        translate([0, 0, -14.0]) {
            for (a = [0 : 90 : 270]) {
                rotate([0, 0, a]) translate([18.0, 0, 0]) cylinder(d=3.2, h=10.0);
            }
        }
        if (Emboss_Meraki_Hallmark) {
            translate([0, 22.1, 0]) rotate([90, 0, 0]) Meraki_Hallmark(size=2.8, depth=0.6);
        }
    }

    translate([-26.0, 0, 24.0]) Gripper_Finger(true);
    translate([ 26.0, 0, 24.0]) Gripper_Finger(false);
}

module Gripper_Finger(is_left) {
    mirror([is_left ? 0 : 1, 0, 0]) {
        difference() {
            union() {
                cube([8.0, 24.0, 48.0]);
                translate([-4.0, -12.0, -10.0]) cube([12.0, 24.0, 12.0]);
            }
            translate([2.0, 0, -4.0]) rotate([0, 90, 0]) cylinder(d=3.3, h=15.0, center=true);
        }
        translate([8.0, -10.0, 10.0]) color([0.2, 0.8, 0.3]) cube([2.5, 20.0, 36.0]);
    }
}

// ====================================================================
// MODULE: DESKTOP AI COMPANION POD (GEMMA MINI)
// ====================================================================
module Desktop_Companion_Pod() {
    difference() {
        hull() {
            translate([15, 15, 0]) cylinder(r=15, h=110.0);
            translate([95, 15, 0]) cylinder(r=15, h=110.0);
            translate([85, 85, 0]) cylinder(r=15, h=95.0);
            translate([25, 85, 0]) cylinder(r=15, h=95.0);
        }

        translate([12.0, 12.0, 4.0])
            hull() {
                translate([10, 10, 0]) cylinder(r=10, h=110.0);
                translate([76, 10, 0]) cylinder(r=10, h=110.0);
                translate([68, 68, 0]) cylinder(r=10, h=95.0);
                translate([18, 68, 0]) cylinder(r=10, h=95.0);
            }

        translate([55.0, 5.0, 60.0]) rotate([15, 0, 0]) cube([78.0, 12.0, 52.0], center=true);
        translate([0, 48.0, 45.0]) rotate([0, 90, 0]) Speaker_Grill();
        translate([110.0, 48.0, 45.0]) rotate([0, 90, 0]) Speaker_Grill();

        translate([55.0, 48.0, 105.0]) {
            cylinder(d=45.0, h=10.0);
            for (a = [0 : 90 : 270]) {
                rotate([0, 0, a]) translate([18.0, 0, -2]) cylinder(d=2.5, h=15.0);
            }
        }

        if (Emboss_Meraki_Hallmark) {
            translate([55.0, 84.5, 50.0]) rotate([90, 0, 180]) Meraki_Hallmark(size=4.5, depth=0.8);
        }
    }
}

module Speaker_Grill() {
    for (r = [4 : 4 : 18]) {
        for (a = [0 : 30 : 330]) {
            rotate([0, 0, a]) translate([r, 0, -10]) cylinder(d=1.8, h=25.0);
        }
    }
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
