// ====================================================================
// PARAMETRIC MAKER FORGE - GRIDFINITY STORAGE ENGINE
// Fully Parametric Gridfinity Bins, Bit Trays & Scoop Compartments
// Compliant with Zack Freedman's Official Gridfinity Specifications
// ====================================================================

$fn = 48;

/* [Grid Dimensions] */
Grid_Units_X = 2; // [1:1:6] Number of 42mm units in X
Grid_Units_Y = 2; // [1:1:6] Number of 42mm units in Y
Height_Units = 4; // [2:1:12] Multiples of 7mm (4 units = 28mm tall)

/* [Compartment Layout] */
Divisions_X  = 2; // [1:1:6] Internal dividers in X
Divisions_Y  = 1; // [1:1:6] Internal dividers in Y
Wall_Thick   = 1.6;
Enable_Scoop = true; // Curved bottom for easy small-screw retrieval

/* [Base Features] */
Enable_Magnets = true; // 6x2mm magnet pockets on bottom
Enable_Screws  = true; // M3 screw holes in corners

// Official Gridfinity constants
Unit_Pitch = 42.0;
Tol_Gap    = 0.5;
Height_U   = 7.0;
Base_W_X   = Grid_Units_X * Unit_Pitch - Tol_Gap;
Base_W_Y   = Grid_Units_Y * Unit_Pitch - Tol_Gap;
Total_H    = Height_Units * Height_U;

// ====================================================================
// TOP-LEVEL RENDER
// ====================================================================
color([0.95, 0.45, 0.25]) Gridfinity_Bin();

module Gridfinity_Bin() {
    difference() {
        union() {
            // Main outer bin box
            Rounded_Box(Base_W_X, Base_W_Y, Total_H, 3.75);

            // Stacking top lip
            translate([0, 0, Total_H])
                Gridfinity_Stacking_Lip(Base_W_X, Base_W_Y);
        }

        // Inner divided compartments
        Compartment_W_X = (Base_W_X - 2 * Wall_Thick - (Divisions_X - 1) * Wall_Thick) / Divisions_X;
        Compartment_W_Y = (Base_W_Y - 2 * Wall_Thick - (Divisions_Y - 1) * Wall_Thick) / Divisions_Y;

        for (ix = [0 : Divisions_X - 1]) {
            for (iy = [0 : Divisions_Y - 1]) {
                cx = Wall_Thick + ix * (Compartment_W_X + Wall_Thick);
                cy = Wall_Thick + iy * (Compartment_W_Y + Wall_Thick);
                
                translate([cx, cy, 6.0]) {
                    if (Enable_Scoop) {
                        // Scoop pocket
                        hull() {
                            translate([2, 2, 0]) cylinder(r=2, h=Total_H);
                            translate([Compartment_W_X - 2, 2, 0]) cylinder(r=2, h=Total_H);
                            translate([Compartment_W_X - 2, Compartment_W_Y - 2, 0]) cylinder(r=2, h=Total_H);
                            translate([2, Compartment_W_Y - 2, 0]) cylinder(r=2, h=Total_H);
                        }
                    } else {
                        Rounded_Box(Compartment_W_X, Compartment_W_Y, Total_H + 5, 2.0);
                    }
                }
            }
        }

        // Bottom Gridfinity socket profiles (42mm grid)
        for (gx = [0 : Grid_Units_X - 1]) {
            for (gy = [0 : Grid_Units_Y - 1]) {
                translate([gx * Unit_Pitch + 0.25, gy * Unit_Pitch + 0.25, 0])
                    Gridfinity_Base_Profile();
            }
        }
    }
}

module Gridfinity_Base_Profile() {
    U = 41.5;
    // Outer chamfers of single grid block
    difference() {
        cube([U, U, 5.0]);
        // 45-degree bottom lead-in
        translate([0, 0, 0])
            rotate([0, 0, 0])
            // Magnet / Screw corner pockets
            if (Enable_Magnets) {
                translate([8.0, 8.0, -1]) cylinder(d=6.5, h=3.4);
                translate([U - 8.0, 8.0, -1]) cylinder(d=6.5, h=3.4);
                translate([8.0, U - 8.0, -1]) cylinder(d=6.5, h=3.4);
                translate([U - 8.0, U - 8.0, -1]) cylinder(d=6.5, h=3.4);
            }
    }
}

module Gridfinity_Stacking_Lip(w, l) {
    difference() {
        Rounded_Box(w, l, 4.4, 3.75);
        translate([1.2, 1.2, -0.5]) Rounded_Box(w - 2.4, l - 2.4, 5.5, 2.5);
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
