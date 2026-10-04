// ====================================================================
// PARAMETRIC MAKER FORGE - SMARTPHONE CASE ENGINE
// Shockproof TPU / Hybrid Case with Camera Island Bezel & MagSafe Pocket
// ====================================================================

$fn = 64;

/* [Phone Model Preset] */
Phone_Model = "IPHONE_16_PRO"; // [IPHONE_16_PRO:Apple iPhone 16 Pro, IPHONE_16_PRO_MAX:iPhone 16 Pro Max, IPHONE_15_PRO:iPhone 15 Pro, SAMSUNG_S25_ULTRA:Samsung Galaxy S25 Ultra, PIXEL_9_PRO:Google Pixel 9 Pro, CUSTOM:Custom Dimensions]

/* [Case Features] */
Enable_MagSafe_Pocket = true;  // Recessed pocket for 54/60mm magnetic sticker ring
Enable_Corner_Airbags = true;  // Hollow air-cushion cavities on 4 corners for drop impact
Raised_Screen_Lip     = 1.2;   // Wrap-around screen protection lip (mm)
Wall_Thickness        = 2.2;   // Case bumper wall thickness (mm)
Back_Thickness        = 1.8;   // Back shell thickness (mm)

/* [Custom Dimensions (if selected)] */
Custom_Phone_L        = 150.0;
Custom_Phone_W        = 72.0;
Custom_Phone_T        = 8.3;
Custom_Corner_R       = 12.0;

// Model lookup function
function get_phone_specs(model) =
    (model == "IPHONE_16_PRO") ? [149.6, 71.5, 8.25, 12.5, 40.5, 43.0, 4.1] :
    (model == "IPHONE_16_PRO_MAX") ? [163.0, 77.6, 8.25, 13.0, 42.0, 45.0, 4.2] :
    (model == "IPHONE_15_PRO") ? [146.6, 70.6, 8.25, 11.5, 39.5, 42.0, 4.0] :
    (model == "SAMSUNG_S25_ULTRA") ? [162.8, 77.6, 8.2, 4.0, 26.0, 68.0, 3.8] :
    (model == "PIXEL_9_PRO") ? [152.8, 72.0, 8.5, 13.0, 68.0, 24.0, 3.6] :
    [Custom_Phone_L, Custom_Phone_W, Custom_Phone_T, Custom_Corner_R, 40.0, 40.0, 4.0];

Specs = get_phone_specs(Phone_Model);
PL = Specs[0]; // Phone Length
PW = Specs[1]; // Phone Width
PT = Specs[2]; // Phone Thickness
PR = Specs[3]; // Corner Radius
Cam_W = Specs[4];
Cam_H = Specs[5];
Cam_D = Specs[6];

Outer_L = PL + 2 * Wall_Thickness;
Outer_W = PW + 2 * Wall_Thickness;
Total_H = PT + Back_Thickness + Raised_Screen_Lip;

// ====================================================================
// TOP-LEVEL RENDER
// ====================================================================
color([0.22, 0.22, 0.25, 0.95]) Phone_Case();

module Phone_Case() {
    difference() {
        union() {
            // Main case outer bumper and back
            Rounded_Box(Outer_L, Outer_W, Total_H, PR + Wall_Thickness);

            // Raised Camera Island Protective Visor / Lip on the back
            translate([Wall_Thickness + 4.0 - 1.5, Outer_W - Wall_Thickness - 4.0 - Cam_H - 1.5, -Cam_D * 0.7])
                Rounded_Box(Cam_W + 3.0, Cam_H + 3.0, Cam_D * 0.7 + 1.0, 8.0);
        }

        // Inner Phone Cavity (Subtracted phone body)
        translate([Wall_Thickness, Wall_Thickness, Back_Thickness])
            Rounded_Box(PL, PW, PT + 10.0, PR);

        // Top Screen Opening (Leaves wrap-around retaining lip)
        translate([Wall_Thickness + 1.0, Wall_Thickness + 1.0, Total_H - Raised_Screen_Lip - 0.5])
            Rounded_Box(PL - 2.0, PW - 2.0, Raised_Screen_Lip + 2.0, max(1.0, PR - 1.0));

        // Camera Bump Cutout Window
        translate([Wall_Thickness + 4.0, Outer_W - Wall_Thickness - 4.0 - Cam_H, -5.0])
            Rounded_Box(Cam_W, Cam_H, 15.0, 7.0);

        // MagSafe Recessed Pocket on the back (54mm ID, 60mm OD, 0.85mm depth)
        if (Enable_MagSafe_Pocket) {
            translate([Outer_L / 2, Outer_W * 0.48, -0.01]) {
                difference() {
                    cylinder(d=60.2, h=0.85);
                    translate([0, 0, -0.5]) cylinder(d=53.8, h=2.0);
                }
                // Alignment magnet slot below ring
                translate([-2.5, -34.0, 0]) cube([5.0, 9.0, 0.85]);
            }
        }

        // Bottom USB-C Port & Speaker Cutouts
        translate([Outer_L / 2 - 7.0, -1.0, Back_Thickness + PT / 2 - 3.25])
            cube([14.0, Wall_Thickness + 2, 6.5]); // USB-C
        translate([Outer_L / 2 - 25.0, -1.0, Back_Thickness + PT / 2 - 2.0])
            cube([12.0, Wall_Thickness + 2, 4.0]); // Mic
        translate([Outer_L / 2 + 13.0, -1.0, Back_Thickness + PT / 2 - 2.0])
            cube([14.0, Wall_Thickness + 2, 4.0]); // Speaker

        // Side Button Flexible Cantilever Slits
        // Volume buttons (Left)
        translate([-1.0, Outer_W * 0.62, Back_Thickness + 2.0])
            cube([Wall_Thickness + 2, 28.0, PT - 2.0]);
        // Power button (Right)
        translate([Outer_L - Wall_Thickness - 1.0, Outer_W * 0.58, Back_Thickness + 2.0])
            cube([Wall_Thickness + 2, 20.0, PT - 2.0]);

        // Corner Drop Cushion Air Pockets
        if (Enable_Corner_Airbags) {
            Corner_Air_Pocket(PR, PR);
            Corner_Air_Pocket(Outer_L - PR, PR);
            Corner_Air_Pocket(PR, Outer_W - PR);
            Corner_Air_Pocket(Outer_L - PR, Outer_W - PR);
        }

        // Debossed Model Identification inside case
        translate([Outer_L / 2, Outer_W / 2, Back_Thickness - 0.4])
            linear_extrude(0.5)
            text(Phone_Model, size=3.5, halign="center", valign="center", font="Liberation Sans:style=Bold");
    }
}

module Corner_Air_Pocket(x, y) {
    translate([x, y, Back_Thickness + 1.0])
        cylinder(d=2.8, h=PT - 2.0);
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
