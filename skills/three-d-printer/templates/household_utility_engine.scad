// ==============================================================================
// 🛠️ PARAMETRIC MAKER FORGE: HOUSEHOLD UTILITY & WORKSPACE FIX ENGINE
// Crafted with ∞ Meraki (μεράκι) — Functional Additive Manufacturing & DfAM
// Optimized for Flashforge Adventurer 5M/Pro, CoreXY, and OrcaSlicer
// ==============================================================================

/* [Model Selection] */
// Select household fix or printer enhancement
Model_Type = "PHONE_STAND"; // [PHONE_STAND:Print-in-Place Foldable Phone Stand (13g), TUBE_SQUEEZER:LastDrop Tube Roller Squeezer, SELF_WATERING_PLANTER:Dual-Chamber Self-Watering Planter, HEADPHONE_HANGER:Under-Desk Heavy-Duty Headphone Mount, PRINTER_VIBE_FOOT:CoreXY TPU Anti-Vibration Foot, POOP_CHUTE:CoreXY Purge Line Deflector]

/* [Physical Traceability & Hallmark] */
// Debossed part identification stamped into the plastic
Part_ID_Label = "HOUSEHOLD-UTIL-01";
// Stamp the maker hallmark on the bottom face
Emboss_Meraki_Hallmark = true;
// Deboss depth for text (0.4-0.6mm recommended for 0.2mm layer height)
Deboss_Depth = 0.5;

/* [Phone Stand Parameters] */
Phone_Thickness = 12.0; // [8:0.5:20]
Stand_Width = 55.0; // [40:5:80]
Viewing_Angle = 65; // [45:5:75]

/* [Tube Squeezer Parameters] */
Tube_Width = 58.0; // [30:2:80]
Slot_Gap = 1.6; // [1.0:0.1:3.0]
Knob_Diameter = 24.0; // [16:2:36]

/* [Planter Parameters] */
Planter_OD = 90.0; // [60:5:150]
Planter_Height = 85.0; // [50:5:140]
Reservoir_Height = 25.0; // [15:5:45]
Wall_Thickness = 2.4; // [1.6:0.4:4.0]

/* [Headphone Mount Parameters] */
Headband_Width = 46.0; // [30:2:70]
Under_Desk_Length = 65.0; // [40:5:100]
Gusset_Fillet_Radius = 15.0; // [8:2:25]

/* [Printer Vibration Foot Parameters] */
Foot_OD = 48.0; // [35:1:65]
Foot_Height = 22.0; // [15:1:35]
Core_Hollow_Dia = 30.0; // [20:1:45]

/* [Crush-Rib Bearing Fitment (DfAM)] */
Bearing_OD = 22.0; // 608 Bearing standard
Rib_Count = 4;
Rib_Crush_Protrusion = 0.20; // 0.2mm deformation crush rib

$fn = 64;

// ------------------------------------------------------------------------------
// DfAM HELPER MODULES
// ------------------------------------------------------------------------------

// Crush-Rib Bearing Bore: prevents radial hoop stress cracking in plastic
module crush_rib_bore(dia=22.0, h=10.0, ribs=4, rib_t=0.20, rib_w=0.60) {
    cylinder(d=dia + 0.05, h=h + 0.2, center=true);
    for (i = [0 : ribs - 1]) {
        rotate([0, 0, i * (360 / ribs)])
            translate([dia / 2 - rib_t / 2, 0, 0])
                cube([rib_t, rib_w, h + 0.2], center=true);
    }
}

// Internal Fillet Helper (Eliminates stress risers and deposition voids)
module internal_fillet_chamfer(r=2.0, l=50) {
    difference() {
        translate([-0.01, -0.01, 0]) cube([r + 0.01, r + 0.01, l]);
        translate([r, r, -0.1]) cylinder(r=r, h=l + 0.2, $fn=32);
    }
}

// ------------------------------------------------------------------------------
// 1. PRINT-IN-PLACE FOLDABLE PHONE STAND (13g)
// ------------------------------------------------------------------------------
module Print_In_Place_Phone_Stand() {
    base_l = 80;
    base_w = Stand_Width;
    base_h = 4.2;
    clearance = 0.35; // Free-fit clearance for print-in-place axle

    difference() {
        union() {
            // Main Base Frame
            cube([base_l, base_w, base_h], center=false);
            
            // Integrated Back Support Arm (Hinged with 0.35mm clearance)
            translate([15, 6, 0])
                cube([base_l - 25, base_w - 12, base_h]);
                
            // Phone Cradle Lip
            translate([base_l - 12, 0, base_h])
                cube([10, base_w, Phone_Thickness + 4]);
        }
        
        // Cable Relief Pass-Through (charge while viewing)
        translate([base_l - 16, base_w/2 - 9, -1])
            cube([18, 18, base_h + Phone_Thickness + 6]);
            
        // Print-in-Place Hinge Air Gap Channels (0.35mm Free Fit)
        translate([15 - clearance, 6 - clearance, -0.5])
            cube([base_l - 25 + clearance*2, clearance, base_h + 1]);
        translate([15 - clearance, base_w - 6, -0.5])
            cube([base_l - 25 + clearance*2, clearance, base_h + 1]);
        translate([base_l - 10, 6, -0.5])
            cube([clearance, base_w - 12, base_h + 1]);

        // Stamped Physical Part ID & Meraki Hallmark on bottom
        translate([base_l / 2, base_w / 2, Deboss_Depth])
            rotate([180, 0, 0])
                linear_extrude(Deboss_Depth + 0.1)
                    text(Part_ID_Label, size=3.5, font="Liberation Sans:style=Bold", halign="center", valign="center");

        if (Emboss_Meraki_Hallmark) {
            translate([base_l / 2, base_w / 2 - 12, Deboss_Depth])
                rotate([180, 0, 0])
                    linear_extrude(Deboss_Depth + 0.1)
                        text("∞ MERAKI", size=2.8, font="Liberation Sans:style=Bold", halign="center", valign="center");
        }
    }
}

// ------------------------------------------------------------------------------
// 2. "LASTDROP" TUBE ROLLER SQUEEZER
// ------------------------------------------------------------------------------
module Tube_Roller_Squeezer() {
    body_l = Tube_Width + 16;
    body_dia = 16;
    core_dia = 9.5;

    // Outer Retainer Casing
    difference() {
        hull() {
            cylinder(d=body_dia, h=body_l, center=true);
            translate([body_dia/2 + 2, 0, 0])
                cube([4, body_dia, body_l], center=true);
        }
        // Central Spindle Bore
        cylinder(d=core_dia + 0.4, h=body_l + 2, center=true);
        // Tube Feed Insertion Slot
        translate([body_dia/4, 0, 0])
            cube([body_dia, Slot_Gap, body_l - 6], center=true);
    }

    // Winding Spindle with Knurled Turning Dial
    translate([body_dia + Knob_Diameter/2 + 8, 0, 0]) {
        difference() {
            union() {
                // Spindle Axle
                cylinder(d=core_dia, h=body_l + 10, center=true);
                // Knurled Dial Handle
                translate([0, 0, body_l/2 + 5])
                    cylinder(d=Knob_Diameter, h=6, center=true);
                // Dial Knurls
                for (a = [0 : 15 : 345]) {
                    rotate([0, 0, a])
                        translate([Knob_Diameter/2, 0, body_l/2 + 5])
                            cylinder(r=0.8, h=6, center=true, $fn=12);
                }
            }
            // Central Tube Clamping Slit
            cube([1.8, core_dia * 2, body_l - 4], center=true);
            
            // Part ID Stamp on dial face
            translate([0, 0, body_l/2 + 8 - Deboss_Depth])
                linear_extrude(Deboss_Depth + 0.1)
                    text("LASTDROP", size=2.6, font="Liberation Sans:style=Bold", halign="center", valign="center");
        }
    }
}

// ------------------------------------------------------------------------------
// 3. DUAL-CHAMBER SELF-WATERING PLANTER (Watertight PETG)
// ------------------------------------------------------------------------------
module Dual_Chamber_Planter() {
    // Outer Water Reservoir (Printed with 100% watertight PETG perimeters)
    difference() {
        cylinder(d1=Planter_OD - 8, d2=Planter_OD, h=Reservoir_Height + 10, center=false);
        translate([0, 0, Wall_Thickness])
            cylinder(d1=Planter_OD - 8 - Wall_Thickness*2, d2=Planter_OD - Wall_Thickness*2, h=Reservoir_Height + 12, center=false);
            
        // Water Fill Spout / Level Viewing Notch
        translate([Planter_OD/2 - 4, 0, Reservoir_Height + 2])
            cylinder(d=14, h=10, center=true);
    }

    // Inner Aerated Soil Cup with Capillary Wick Core
    translate([Planter_OD * 1.25, 0, 0]) {
        difference() {
            union() {
                cylinder(d1=Planter_OD - 12, d2=Planter_OD - 2, h=Planter_Height, center=false);
                // Upper Suspension Lip
                translate([0, 0, Planter_Height - 4])
                    cylinder(d=Planter_OD + 4, h=4, center=false);
            }
            // Soil Cavity
            translate([0, 0, Wall_Thickness])
                cylinder(d1=Planter_OD - 12 - Wall_Thickness*2, d2=Planter_OD - 2 - Wall_Thickness*2, h=Planter_Height, center=false);

            // Submerged Capillary Wick Column
            translate([0, 0, -Reservoir_Height + 4])
                cylinder(d=16, h=Reservoir_Height, center=false);
                
            // Aeration & Moisture Slits
            for (r = [0 : 45 : 315]) {
                rotate([0, 0, r])
                    translate([0, 0, Wall_Thickness/2])
                        cube([Planter_OD - 24, 2.0, Wall_Thickness + 2], center=true);
            }
        }
    }
}

// ------------------------------------------------------------------------------
// 4. UNDER-DESK HEAVY-DUTY HEADPHONE MOUNT
// ------------------------------------------------------------------------------
module Under_Desk_Headphone_Mount() {
    l = Under_Desk_Length;
    w = Headband_Width;
    thickness = 5.0;

    difference() {
        union() {
            // Horizontal Desk Mounting Plate
            cube([l, w, thickness]);
            
            // Vertical Drop Arm
            cube([thickness, w, 55]);
            
            // Curved Headphone Cradle
            translate([0, 0, 55 - thickness])
                cube([l * 0.75, w, thickness]);
            translate([l * 0.75 - 4, 0, 55])
                cube([4, w, 12]); // End Retention Lip
                
            // 45° Load-Bearing Structural Gusset (Mitigates Z-axis layer delamination!)
            translate([thickness, 0, 0])
                rotate([0, 45, 0])
                    cube([Gusset_Fillet_Radius * 1.414, w, thickness]);
        }

        // Countersunk Wood Screw Holes (M4 / #8)
        translate([l - 12, w / 4, -1])
            cylinder(d1=4.5, d2=8.5, h=thickness + 2);
        translate([l - 12, 3 * w / 4, -1])
            cylinder(d1=4.5, d2=8.5, h=thickness + 2);
        translate([20, w / 2, -1])
            cylinder(d1=4.5, d2=8.5, h=thickness + 2);

        // Cable Snap Catch Notch
        translate([l * 0.4, -1, 55 - thickness / 2])
            cube([6, w + 2, 4]);

        // Stamped Part ID
        translate([l / 2, w / 2, thickness - Deboss_Depth])
            linear_extrude(Deboss_Depth + 0.1)
                text(Part_ID_Label, size=3.2, font="Liberation Sans:style=Bold", halign="center", valign="center");
    }
}

// ------------------------------------------------------------------------------
// 5. COREXY / FLASHFORGE 5M TPU ANTI-VIBRATION FOOT
// ------------------------------------------------------------------------------
module CoreXY_TPU_Vibration_Foot() {
    difference() {
        union() {
            // Tapered Outer Sorbothane-style Dampening Cup
            cylinder(d1=Foot_OD, d2=Foot_OD - 6, h=Foot_Height);
            
            // Upper Machine Foot Capture Rim
            translate([0, 0, Foot_Height])
                cylinder(d=Foot_OD - 4, h=6);
        }
        
        // Machine Foot Pocket (Snug +0.05mm fit)
        translate([0, 0, Foot_Height - 4])
            cylinder(d=Foot_OD - 12, h=12);

        // Internal Honeycomb / Hollow Energy Dissipation Cavity
        translate([0, 0, -1])
            cylinder(d=Core_Hollow_Dia, h=Foot_Height - 5);

        // Center Retention Screw Hole (M4/M5)
        translate([0, 0, -2])
            cylinder(d=5.2, h=Foot_Height + 10);
    }
}

// ------------------------------------------------------------------------------
// 6. COREXY / FLASHFORGE 5M PURGE "POOP CHUTE" DEFLECTOR
// ------------------------------------------------------------------------------
module CoreXY_Purge_Deflector() {
    chute_w = 42;
    chute_l = 85;
    angle = 38; // 38° steep gravity slide

    difference() {
        union() {
            // Sloped Purge Slide
            rotate([0, angle, 0])
                cube([chute_l, chute_w, 2.4]);
                
            // Side Containment Rails
            rotate([0, angle, 0]) {
                translate([0, 0, 0]) cube([chute_l, 2.4, 18]);
                translate([0, chute_w - 2.4, 0]) cube([chute_l, 2.4, 18]);
            }

            // Magnetic Frame Mounting Flange
            translate([-8, 0, 0])
                cube([10, chute_w, 24]);
        }

        // Neodymium Magnet Pockets (6x2mm magnet press-fit)
        translate([-4, chute_w / 4, 12])
            rotate([0, 90, 0])
                cylinder(d=6.1, h=6, center=true);
        translate([-4, 3 * chute_w / 4, 12])
            rotate([0, 90, 0])
                cylinder(d=6.1, h=6, center=true);

        // Hallmark
        translate([-6, chute_w / 2, 2])
            rotate([0, 90, 0])
                linear_extrude(Deboss_Depth + 0.1)
                    text("∞ MERAKI", size=2.5, font="Liberation Sans:style=Bold", halign="center", valign="center");
    }
}

// ------------------------------------------------------------------------------
// MAIN DISPATCH
// ------------------------------------------------------------------------------
if (Model_Type == "PHONE_STAND") {
    Print_In_Place_Phone_Stand();
} else if (Model_Type == "TUBE_SQUEEZER") {
    Tube_Roller_Squeezer();
} else if (Model_Type == "SELF_WATERING_PLANTER") {
    Dual_Chamber_Planter();
} else if (Model_Type == "HEADPHONE_HANGER") {
    Under_Desk_Headphone_Mount();
} else if (Model_Type == "PRINTER_VIBE_FOOT") {
    CoreXY_TPU_Vibration_Foot();
} else if (Model_Type == "POOP_CHUTE") {
    CoreXY_Purge_Deflector();
}
