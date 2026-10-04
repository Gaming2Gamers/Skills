// ====================================================================
// PARAMETRIC MAKER FORGE - KNOB & DIAL REPLACEMENT ENGINE
// D-Shaft, 18T/24T Splined, Knurled, Fluted & Set-Screw Retention
// ====================================================================

$fn = 64;

/* [Shaft Fitting] */
Shaft_Profile    = "D_SHAFT"; // [D_SHAFT:D-Shaft Flat, ROUND_SET_SCREW:Smooth Round with M3 Set Screw, SPLINED_18T:18-Tooth Potentiometer Spline, HEX_SHAFT:Hexagonal Socket]
Shaft_Dia        = 6.0;  // 6.0mm or 6.35mm (1/4 inch)
D_Flat_Depth     = 1.5;  // Depth of the D flat
Shaft_Depth      = 12.0; // Engagement depth

/* [Knob Outer Dimensions] */
Knob_Diameter    = 28.0; // [14:1:80]
Knob_Height      = 16.0; // [8:1:50]
Grip_Texture     = "DIAMOND_KNURL"; // [DIAMOND_KNURL:Diamond Knurled, FLUTED_RIBS:Vertical Finger Flutes, SMOOTH_POINTER:Smooth with Indicator Notch]
Rib_Count        = 18;

/* [Pointer & Indicators] */
Enable_Pointer   = true;
Pointer_Style    = "EMBOSSED_LINE"; // [EMBOSSED_LINE:Raised Line, DEBOSSED_DOT:Debossed Dot]

// ====================================================================
// TOP-LEVEL RENDER
// ====================================================================
color([0.25, 0.25, 0.28]) Knob_Assembly();

module Knob_Assembly() {
    difference() {
        union() {
            // Main knob body
            cylinder(d=Knob_Diameter, h=Knob_Height);

            // Grip texture on perimeter
            if (Grip_Texture == "FLUTED_RIBS") {
                for (i = [0 : Rib_Count - 1]) {
                    rotate([0, 0, i * (360 / Rib_Count)])
                        translate([Knob_Diameter / 2, 0, 0])
                        cylinder(d=2.0, h=Knob_Height);
                }
            } else if (Grip_Texture == "DIAMOND_KNURL") {
                for (i = [0 : Rib_Count * 2 - 1]) {
                    rotate([0, 0, i * (180 / Rib_Count)])
                        translate([Knob_Diameter / 2, 0, 0])
                        rotate([0, 0, 45])
                        cube([1.2, 1.2, Knob_Height], center=true);
                }
            }

            // Pointer indicator
            if (Enable_Pointer && Pointer_Style == "EMBOSSED_LINE") {
                translate([0, Knob_Diameter / 4, Knob_Height])
                    cube([1.6, Knob_Diameter / 2, 0.8], center=true);
            }
        }

        // Shaft socket cavity
        translate([0, 0, -1]) {
            if (Shaft_Profile == "D_SHAFT") {
                difference() {
                    cylinder(d=Shaft_Dia + 0.15, h=Shaft_Depth + 1);
                    translate([Shaft_Dia / 2 - D_Flat_Depth + 0.05, -Shaft_Dia, 0])
                        cube([Shaft_Dia, Shaft_Dia * 2, Shaft_Depth + 2]);
                }
            } else if (Shaft_Profile == "ROUND_SET_SCREW") {
                cylinder(d=Shaft_Dia + 0.15, h=Shaft_Depth + 1);
            } else if (Shaft_Profile == "HEX_SHAFT") {
                cylinder(d=(Shaft_Dia + 0.2) / cos(30), h=Shaft_Depth + 1, $fn=6);
            } else if (Shaft_Profile == "SPLINED_18T") {
                cylinder(d=Shaft_Dia + 0.1, h=Shaft_Depth + 1);
                for (a = [0 : 20 : 360]) {
                    rotate([0, 0, a]) translate([Shaft_Dia / 2, 0, 0]) cylinder(d=0.8, h=Shaft_Depth + 1);
                }
            }
        }

        // Radial M3 set-screw hole
        if (Shaft_Profile == "ROUND_SET_SCREW" || Shaft_Profile == "D_SHAFT") {
            translate([0, 0, Shaft_Depth / 2])
                rotate([0, 90, 0])
                cylinder(d=2.9, h=Knob_Diameter / 2 + 1); // M3 tap hole
        }

        // Debossed pointer dot
        if (Enable_Pointer && Pointer_Style == "DEBOSSED_DOT") {
            translate([0, Knob_Diameter / 2 - 3.5, Knob_Height - 0.6])
                cylinder(d=2.0, h=1.0);
        }
    }
}
