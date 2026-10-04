// ====================================================================
// PARAMETRIC MAKER FORGE - TPU GASKET & O-RING ENGINE
// O-Rings, Flange Gaskets, Crush-Bead Tongue & Groove Seals
// Designed for flexible 3D printing in TPU 95A / 85A
// ====================================================================

$fn = 96;

/* [Gasket Type] */
Gasket_Type = "CIRCULAR_O_RING"; // [CIRCULAR_O_RING:Circular Toroid O-Ring, RECTANGULAR_FLANGE:Rectangular Flange Gasket with Bolt Holes, TONGUE_AND_GROOVE_STRIP:Linear Interlocking Compression Strip]

/* [Circular O-Ring Parameters] */
O_Ring_Inner_Dia     = 37.5; // [4:0.5:200] Inside diameter in mm
Cross_Section_Dia    = 2.62; // [1.0:0.1:8.0] Cord thickness in mm

/* [Rectangular Flange Parameters] */
Flange_Length        = 85.0; // Outer length in mm
Flange_Width         = 55.0; // Outer width in mm
Gasket_Rib_Width     = 4.5;  // Width of rubber seal band
Gasket_Thickness     = 1.8;  // Height / thickness in mm
Corner_Radius        = 6.0;

/* [Bolt Hole Array (For Flange)] */
Enable_Bolt_Holes    = true;
Bolt_Hole_Dia        = 4.2;  // M4 clearance
Bolt_Pitch_X         = 75.0;
Bolt_Pitch_Y         = 45.0;

/* [Compression Crush Bead] */
Enable_Crush_Bead    = true; // 0.4mm raised ridge on top for lower sealing torque
Crush_Bead_Height    = 0.45;

/* [Material Stamp] */
Emboss_Spec_Label    = true;
Gasket_Spec_Label    = "TPU-95A CS:2.6mm";

// ====================================================================
// TOP-LEVEL RENDER
// ====================================================================
if (Gasket_Type == "CIRCULAR_O_RING") {
    color([0.15, 0.75, 0.35, 0.9]) Circular_O_Ring();
} else if (Gasket_Type == "RECTANGULAR_FLANGE") {
    color([0.25, 0.85, 0.45, 0.9]) Rectangular_Flange_Gasket();
} else if (Gasket_Type == "TONGUE_AND_GROOVE_STRIP") {
    color([0.15, 0.65, 0.35, 0.9]) Compression_Strip();
}

module Circular_O_Ring() {
    R_Toroid = O_Ring_Inner_Dia / 2 + Cross_Section_Dia / 2;
    rotate_extrude()
        translate([R_Toroid, 0, 0])
        circle(d=Cross_Section_Dia);
}

module Rectangular_Flange_Gasket() {
    difference() {
        union() {
            // Main flat gasket band
            linear_extrude(Gasket_Thickness) {
                difference() {
                    Rounded_Plate_2D(Flange_Length, Flange_Width, Corner_Radius);
                    offset(r=-Gasket_Rib_Width)
                        Rounded_Plate_2D(Flange_Length, Flange_Width, Corner_Radius);
                }
            }

            // Raised compression crush bead along centerline of seal
            if (Enable_Crush_Bead) {
                translate([0, 0, Gasket_Thickness])
                    linear_extrude(Crush_Bead_Height) {
                        difference() {
                            offset(r=-Gasket_Rib_Width / 2 + 0.4)
                                Rounded_Plate_2D(Flange_Length, Flange_Width, Corner_Radius);
                            offset(r=-Gasket_Rib_Width / 2 - 0.4)
                                Rounded_Plate_2D(Flange_Length, Flange_Width, Corner_Radius);
                        }
                    }
            }

            // Corner bolt hole mounting tabs
            if (Enable_Bolt_Holes) {
                Corner_Bolt_Tab(Flange_Length / 2 - Bolt_Pitch_X / 2, Flange_Width / 2 - Bolt_Pitch_Y / 2);
                Corner_Bolt_Tab(Flange_Length / 2 + Bolt_Pitch_X / 2, Flange_Width / 2 - Bolt_Pitch_Y / 2);
                Corner_Bolt_Tab(Flange_Length / 2 - Bolt_Pitch_X / 2, Flange_Width / 2 + Bolt_Pitch_Y / 2);
                Corner_Bolt_Tab(Flange_Length / 2 + Bolt_Pitch_X / 2, Flange_Width / 2 + Bolt_Pitch_Y / 2);
            }
        }

        // Bolt clearance holes
        if (Enable_Bolt_Holes) {
            translate([Flange_Length / 2 - Bolt_Pitch_X / 2, Flange_Width / 2 - Bolt_Pitch_Y / 2, -1]) cylinder(d=Bolt_Hole_Dia, h=Gasket_Thickness + 3);
            translate([Flange_Length / 2 + Bolt_Pitch_X / 2, Flange_Width / 2 - Bolt_Pitch_Y / 2, -1]) cylinder(d=Bolt_Hole_Dia, h=Gasket_Thickness + 3);
            translate([Flange_Length / 2 - Bolt_Pitch_X / 2, Flange_Width / 2 + Bolt_Pitch_Y / 2, -1]) cylinder(d=Bolt_Hole_Dia, h=Gasket_Thickness + 3);
            translate([Flange_Length / 2 + Bolt_Pitch_X / 2, Flange_Width / 2 + Bolt_Pitch_Y / 2, -1]) cylinder(d=Bolt_Hole_Dia, h=Gasket_Thickness + 3);
        }

        // Material spec label
        if (Emboss_Spec_Label) {
            translate([Flange_Length / 2, 2.2, Gasket_Thickness - 0.4])
                linear_extrude(0.5)
                text(Gasket_Spec_Label, size=1.8, halign="center", valign="center", font="Liberation Sans:style=Bold");
        }
    }
}

module Corner_Bolt_Tab(x, y) {
    translate([x, y, 0])
        cylinder(d=Bolt_Hole_Dia + 6.0, h=Gasket_Thickness);
}

module Rounded_Plate_2D(length, width, radius) {
    r = min(radius, length / 2 - 0.1, width / 2 - 0.1);
    hull() {
        translate([r, r]) circle(r=r);
        translate([length - r, r]) circle(r=r);
        translate([length - r, width - r]) circle(r=r);
        translate([r, width - r]) circle(r=r);
    }
}

module Compression_Strip() {
    cube([100.0, 6.0, 2.5]);
    translate([0, 3.0, 2.5])
        rotate([0, 90, 0])
        cylinder(r=1.2, h=100.0);
}
