// ====================================================================
// FIT CHECK TEST COUPON - 3-MINUTE CALIBRATION PRINT (~1.2g filament)
// ====================================================================
// Print this micro coupon FIRST before printing large enclosures or jigs!
// It tests your printer's exact hole diameter shrinkage and snap-fit flex.
// ====================================================================

$fn = 64;

/* [Options] */
Coupon_Length = 45;
Coupon_Width  = 20;
Coupon_Thick  = 4.0;

difference() {
    // Base plate with rounded corners
    hull() {
        translate([2, 2, 0]) cylinder(r=2, h=Coupon_Thick);
        translate([Coupon_Length-2, 2, 0]) cylinder(r=2, h=Coupon_Thick);
        translate([Coupon_Length-2, Coupon_Width-2, 0]) cylinder(r=2, h=Coupon_Thick);
        translate([2, Coupon_Width-2, 0]) cylinder(r=2, h=Coupon_Thick);
    }

    // Hole 1: 3.8mm (Tight M3 Heat-Set)
    translate([8, 10, -0.5]) cylinder(d=3.8, h=Coupon_Thick + 1);
    // Hole 2: 4.0mm (Standard Ruthex M3 Heat-Set)
    translate([18, 10, -0.5]) cylinder(d=4.0, h=Coupon_Thick + 1);
    // Hole 3: 4.2mm (Loose / ABS Shrink M3 Heat-Set)
    translate([28, 10, -0.5]) cylinder(d=4.2, h=Coupon_Thick + 1);
    // Hole 4: 3.4mm (M3 Screw Clearance Pass-Through)
    translate([38, 10, -0.5]) cylinder(d=3.4, h=Coupon_Thick + 1);

    // Debossed size labels
    translate([8, 3, Coupon_Thick - 0.5]) linear_extrude(0.6) text("3.8", size=2.5, halign="center");
    translate([18, 3, Coupon_Thick - 0.5]) linear_extrude(0.6) text("4.0", size=2.5, halign="center");
    translate([28, 3, Coupon_Thick - 0.5]) linear_extrude(0.6) text("4.2", size=2.5, halign="center");
    translate([38, 3, Coupon_Thick - 0.5]) linear_extrude(0.6) text("3.4", size=2.5, halign="center");

    translate([Coupon_Length/2, 16, Coupon_Thick - 0.5]) linear_extrude(0.6) text("M3 FIT CHECK", size=2.2, halign="center");
}

// Snap-fit bead cantilever test tab on side
translate([Coupon_Length, 6, 0]) {
    cube([4, 8, 1.8]);
    translate([3.2, 0, 1.8]) rotate([-90, 0, 0]) cylinder(r=0.6, h=8);
}
