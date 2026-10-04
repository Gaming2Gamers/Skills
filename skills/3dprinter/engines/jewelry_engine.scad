// ====================================================================
// PARAMETRIC MAKER FORGE - BESPOKE JEWELRY & EARRING ENGINE
// Rings, Earrings, Signets, Gyroscopes & Mirrored Pairs
// ====================================================================

$fn = 96;

/* [Jewelry Model Selection] */
Jewelry_Model = "EARRING_TEARDROP_LACE"; // [SIGNET_RING:Modern Signet Ring, FACETED_BAND:Geometric Faceted Band, GYRO_PENDANT:Print-in-Place Gyroscopic Pendant, EARRING_TEARDROP_LACE:Lace Teardrop Dangle Earring, EARRING_SPIRAL_DROP:Kinetic Spiral Drop Earring, EARRING_TWIST_HOOP:Mobius Twisted Hoop Earring]

/* [Pair & Layout Export] */
Export_Layout = "PAIR_MIRRORED"; // [SINGLE:Single Piece, PAIR_MIRRORED:Mirrored Pair (Left & Right), PAIR_IDENTICAL:Two Identical Pieces]

/* [Earring Sizing & Findings] */
Earring_Length       = 42.0; // [20:1:70]
Earring_Width        = 24.0; // [12:1:45]
Earring_Thickness    = 1.4;  // [0.8:0.2:3.0] Ultra-lightweight for ear comfort
Eyelet_Hole_Dia      = 1.5;  // Standard for French wire / jump ring
Eyelet_Outer_Dia     = 3.4;

/* [Ring Sizing & Fit] */
Ring_Size_Preset     = "US_9"; // [US_5:US 5 (15.7mm), US_6:US 6 (16.5mm), US_7:US 7 (17.35mm), US_8:US 8 (18.2mm), US_9:US 9 (18.9mm), US_10:US 10 (19.8mm), US_11:US 11 (20.7mm), US_12:US 12 (21.5mm), US_13:US 13 (22.3mm), CUSTOM:Custom Diameter]
Custom_Inner_Dia     = 18.9;   // [12:0.1:30]
Band_Width           = 6.5;    // [2:0.5:16]
Band_Thickness       = 2.2;    // [1.2:0.2:5]
Comfort_Fit_Bevel    = true;   // Rounded inner edge for finger comfort
Engrave_Inner_Size   = true;
Inner_Stamp_Text     = "US 9";

/* [Signet Crest & Monogram] */
Signet_Width         = 14.0;
Signet_Length        = 12.0;
Monogram_Text        = "∞";
Monogram_Depth       = 0.5;

/* [Kinetic Gyro Pendant] */
Outer_Ring_Dia       = 36.0;
Gimbal_Clearance     = 0.35;
Bail_Hole_Dia        = 3.2;

// Lookup helper for ring sizes
function get_ring_dia(preset, custom_val) =
    (preset == "US_5")  ? 15.70 :
    (preset == "US_6")  ? 16.51 :
    (preset == "US_7")  ? 17.35 :
    (preset == "US_8")  ? 18.19 :
    (preset == "US_9")  ? 18.89 :
    (preset == "US_10") ? 19.84 :
    (preset == "US_11") ? 20.68 :
    (preset == "US_12") ? 21.49 :
    (preset == "US_13") ? 22.33 : custom_val;

Inner_D = get_ring_dia(Ring_Size_Preset, Custom_Inner_Dia);
Inner_R = Inner_D / 2;
Outer_R = Inner_R + Band_Thickness;

// ====================================================================
// TOP-LEVEL RENDER DISPATCHER WITH PAIR LAYOUT
// ====================================================================
if (Export_Layout == "SINGLE") {
    Render_Jewelry_Piece();
} else if (Export_Layout == "PAIR_MIRRORED") {
    translate([-Earring_Width * 0.7 - 2, 0, 0])
        Render_Jewelry_Piece();
    translate([Earring_Width * 0.7 + 2, 0, 0])
        mirror([1, 0, 0])
        Render_Jewelry_Piece();
} else if (Export_Layout == "PAIR_IDENTICAL") {
    translate([-Earring_Width * 0.7 - 2, 0, 0])
        Render_Jewelry_Piece();
    translate([Earring_Width * 0.7 + 2, 0, 0])
        Render_Jewelry_Piece();
}

module Render_Jewelry_Piece() {
    if (Jewelry_Model == "SIGNET_RING") {
        color([0.92, 0.82, 0.45]) Signet_Ring();
    } else if (Jewelry_Model == "FACETED_BAND") {
        color([0.88, 0.88, 0.92]) Faceted_Band();
    } else if (Jewelry_Model == "GYRO_PENDANT") {
        color([0.25, 0.75, 0.85]) Gyro_Kinetic_Pendant();
    } else if (Jewelry_Model == "EARRING_TEARDROP_LACE") {
        color([0.95, 0.78, 0.88]) Earring_Teardrop_Lace(); // Rose gold / Silk filament
    } else if (Jewelry_Model == "EARRING_SPIRAL_DROP") {
        color([0.45, 0.85, 0.65]) Earring_Spiral_Drop();
    } else if (Jewelry_Model == "EARRING_TWIST_HOOP") {
        color([0.94, 0.84, 0.42]) Earring_Twist_Hoop();
    }
}

// ====================================================================
// MODULE: EARRING TEARDROP LACE (ULTRA-LIGHTWEIGHT FEATHER DANGLE)
// ====================================================================
module Earring_Teardrop_Lace() {
    linear_extrude(Earring_Thickness) {
        difference() {
            union() {
                // Organic outer teardrop contour
                hull() {
                    circle(r=Earring_Width / 2);
                    translate([0, Earring_Length - Earring_Width / 2]) circle(r=1.8);
                }
                // Top French hook eyelet
                translate([0, Earring_Length - Earring_Width / 2 + Eyelet_Outer_Dia / 2])
                    circle(d=Eyelet_Outer_Dia);
            }

            // Eyelet hole for jump ring
            translate([0, Earring_Length - Earring_Width / 2 + Eyelet_Outer_Dia / 2])
                circle(d=Eyelet_Hole_Dia);

            // Inner hollow with delicate geometric ribs
            offset(r=-1.6)
                hull() {
                    circle(r=Earring_Width / 2);
                    translate([0, Earring_Length - Earring_Width / 2]) circle(r=1.8);
                }
        }

        // Inner geometric lattice web (< 1.5 grams total weight)
        intersection() {
            offset(r=-1.2)
                hull() {
                    circle(r=Earring_Width / 2);
                    translate([0, Earring_Length - Earring_Width / 2]) circle(r=1.8);
                }
            union() {
                for (a = [-45, 0, 45])
                    rotate([0, 0, a])
                    for (i = [-12 : 5 : 12])
                        translate([i, 0]) square([0.7, Earring_Length * 2], center=true);
                // Concentric inner drop rings
                for (r = [4 : 4 : Earring_Width / 2 - 2])
                    difference() {
                        circle(r=r);
                        circle(r=r - 0.7);
                    }
            }
        }
    }
}

// ====================================================================
// MODULE: EARRING SPIRAL DROP (PARAMETRIC LOGARITHMIC TWIST)
// ====================================================================
module Earring_Spiral_Drop() {
    Turns = 2.5;
    Steps = 72;
    linear_extrude(Earring_Thickness) {
        difference() {
            union() {
                for (i = [0 : Steps]) {
                    theta = i * (Turns * 360 / Steps);
                    r_val = (i / Steps) * (Earring_Width / 2);
                    x = r_val * cos(theta);
                    y = (i / Steps) * Earring_Length + r_val * sin(theta) * 0.3;
                    translate([x, y]) circle(d=1.4 + 1.2 * (i / Steps));
                }
                // Eyelet on top
                translate([0, Earring_Length + Eyelet_Outer_Dia / 2])
                    difference() {
                        circle(d=Eyelet_Outer_Dia);
                        circle(d=Eyelet_Hole_Dia);
                    }
            }
        }
    }
}

// ====================================================================
// MODULE: EARRING TWIST HOOP (MOBIUS CONTINUOUS TOROID HOOP)
// ====================================================================
module Earring_Twist_Hoop() {
    Hoop_R = 14.0;
    Wire_R = 1.2;
    difference() {
        rotate_extrude($fn=120)
            translate([Hoop_R, 0, 0])
            rotate([0, 0, 45])
            square([Wire_R * 2, Wire_R * 2], center=true);

        // Top earlobe opening gap (6mm)
        translate([Hoop_R, 0, 0])
            rotate([0, 90, 0])
            cylinder(d=6.0, h=Hoop_R * 2, center=true);
    }
    // Integrated smooth retention bead on one end
    translate([Hoop_R, 3.0, 0]) sphere(r=Wire_R * 1.3);
}

// ====================================================================
// MODULE: SIGNET RING WITH COMFORT FIT & INNER SIZE EMBOSSING
// ====================================================================
module Signet_Ring() {
    difference() {
        union() {
            rotate_extrude()
                translate([Inner_R, 0, 0])
                polygon([
                    [0, -Band_Width / 2],
                    [Band_Thickness, -Band_Width / 2 + 0.8],
                    [Band_Thickness,  Band_Width / 2 - 0.8],
                    [0,  Band_Width / 2]
                ]);

            translate([0, Inner_R + Band_Thickness * 0.8, 0])
                hull() {
                    translate([-Signet_Width / 2, 0, -Signet_Length / 2])
                        cube([Signet_Width, 2.0, Signet_Length]);
                    translate([-Signet_Width / 2 + 1.5, -Band_Thickness * 1.5, -Signet_Length / 2 + 1.5])
                        cube([Signet_Width - 3, 2.0, Signet_Length - 3]);
                }
        }

        translate([0, 0, -Band_Width])
            cylinder(r=Inner_R, h=Band_Width * 2);

        if (Comfort_Fit_Bevel) {
            translate([0, 0, Band_Width / 2 - 0.4])
                cylinder(r1=Inner_R, r2=Inner_R + 0.6, h=0.6);
            translate([0, 0, -Band_Width / 2 - 0.2])
                cylinder(r1=Inner_R + 0.6, r2=Inner_R, h=0.6);
        }

        translate([0, Inner_R + Band_Thickness * 0.8 + 2.01 - Monogram_Depth, 0])
            rotate([90, 0, 0])
            linear_extrude(Monogram_Depth + 0.1)
            text(Monogram_Text, size=min(Signet_Width, Signet_Length) * 0.55, halign="center", valign="center", font="Liberation Sans:style=Bold");

        if (Engrave_Inner_Size) {
            rotate([0, 0, 180])
            translate([0, Inner_R - 0.2, 0])
            rotate([90, 0, 0])
            linear_extrude(0.4)
            text(Inner_Stamp_Text, size=Band_Width * 0.35, halign="center", valign="center", font="Liberation Sans:style=Bold");
        }
    }
}

// ====================================================================
// MODULE: GEOMETRIC FACETED BAND (LOW-POLY MODERN)
// ====================================================================
module Faceted_Band() {
    Facet_Count = 18;
    difference() {
        cylinder(r=Outer_R + 0.5, h=Band_Width, center=true, $fn=Facet_Count);
        cylinder(r=Inner_R, h=Band_Width + 2, center=true, $fn=96);

        translate([0, 0, Band_Width / 2])
            rotate_extrude($fn=Facet_Count)
            translate([Outer_R - 0.4, 0, 0])
            rotate([0, 0, 45]) square([2, 2]);

        translate([0, 0, -Band_Width / 2])
            rotate_extrude($fn=Facet_Count)
            translate([Outer_R - 0.4, 0, 0])
            rotate([0, 0, 45]) square([2, 2]);

        if (Engrave_Inner_Size) {
            rotate([0, 0, 180])
            translate([0, Inner_R - 0.2, 0])
            rotate([90, 0, 0])
            linear_extrude(0.4)
            text(Inner_Stamp_Text, size=Band_Width * 0.35, halign="center", valign="center", font="Liberation Sans:style=Bold");
        }
    }
}

// ====================================================================
// MODULE: PRINT-IN-PLACE GYROSCOPIC PENDANT (3 CONCENTRIC RINGS)
// ====================================================================
module Gyro_Kinetic_Pendant() {
    Ring_Thick = 2.4;
    Ring_Width = 3.2;

    difference() {
        union() {
            cylinder(d=Outer_Ring_Dia, h=Ring_Thick, center=true);
            translate([0, Outer_Ring_Dia / 2 + 3.0, 0])
                difference() {
                    cylinder(d=7.0, h=Ring_Thick, center=true);
                    cylinder(d=Bail_Hole_Dia, h=Ring_Thick + 1, center=true);
                }
        }
        cylinder(d=Outer_Ring_Dia - 2 * Ring_Width, h=Ring_Thick + 2, center=true);
        translate([0, Outer_Ring_Dia / 2 - Ring_Width, 0]) rotate([90, 0, 0]) cylinder(d1=1.6, d2=0.2, h=1.4, center=true);
        translate([0, -(Outer_Ring_Dia / 2 - Ring_Width), 0]) rotate([-90, 0, 0]) cylinder(d1=1.6, d2=0.2, h=1.4, center=true);
    }

    D2 = Outer_Ring_Dia - 2 * Ring_Width - 2 * Gimbal_Clearance;
    difference() {
        union() {
            cylinder(d=D2, h=Ring_Thick, center=true);
            translate([0, D2 / 2 + 0.3, 0]) rotate([90, 0, 0]) cylinder(d1=1.4, d2=0.2, h=1.0, center=true);
            translate([0, -(D2 / 2 + 0.3), 0]) rotate([-90, 0, 0]) cylinder(d1=1.4, d2=0.2, h=1.0, center=true);
        }
        cylinder(d=D2 - 2 * Ring_Width, h=Ring_Thick + 2, center=true);
        translate([D2 / 2 - Ring_Width, 0, 0]) rotate([0, 90, 0]) cylinder(d1=1.6, d2=0.2, h=1.4, center=true);
        translate([-(D2 / 2 - Ring_Width), 0, 0]) rotate([0, -90, 0]) cylinder(d1=1.6, d2=0.2, h=1.4, center=true);
    }

    D3 = D2 - 2 * Ring_Width - 2 * Gimbal_Clearance;
    union() {
        difference() {
            cylinder(d=D3, h=Ring_Thick, center=true);
            cylinder(d=D3 - 2 * Ring_Width, h=Ring_Thick + 2, center=true);
        }
        translate([D3 / 2 + 0.3, 0, 0]) rotate([0, 90, 0]) cylinder(d1=1.4, d2=0.2, h=1.0, center=true);
        translate([-(D3 / 2 + 0.3), 0, 0]) rotate([0, -90, 0]) cylinder(d1=1.4, d2=0.2, h=1.0, center=true);
        sphere(d=3.8);
    }
}
