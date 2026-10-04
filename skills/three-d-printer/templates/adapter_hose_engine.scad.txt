// ====================================================================
// PARAMETRIC MAKER FORGE - ADAPTER & HOSE ENGINE
// Stepped Loft Adapters, Magnetic Dust Locks, & Twist Bayonets
// ====================================================================

$fn = 72;

/* [Adapter Mode] */
Adapter_Type = "STEPPED_TAPER"; // [STEPPED_TAPER:Smooth Tapered Reducer, MAGNETIC_DUST_LOCK:Magnetic Quick-Disconnect Flange, TWIST_BAYONET:Festool/DeWalt Twist-Lock]

/* [Port 1 (Tool / Machine Side)] */
Port_1_Label   = "SHOP-VAC 2.5IN";
Port_1_OD_Tip  = 57.15;
Port_1_OD_Base = 58.74;
Port_1_Length  = 38.0;

/* [Port 2 (Hose / Extractor Side)] */
Port_2_Label   = "FESTOOL D27";
Port_2_ID_Tip  = 27.2;
Port_2_ID_Base = 26.5;
Port_2_Length  = 32.0;

/* [Transition Section] */
Transition_Length = 28.0;
Wall_Thickness    = 2.4;

/* [Magnetic Lock Settings] */
Magnet_Count      = 8;
Magnet_Hole_Dia   = 10.25; // 10mm Neodymium
Magnet_Hole_Depth = 3.2;
O_Ring_Groove_D   = 72.0;

// ====================================================================
// TOP-LEVEL RENDER
// ====================================================================
if (Adapter_Type == "STEPPED_TAPER") {
    Stepped_Taper_Adapter();
} else if (Adapter_Type == "MAGNETIC_DUST_LOCK") {
    Magnetic_Dust_Lock_Flange();
} else if (Adapter_Type == "TWIST_BAYONET") {
    Twist_Bayonet_Coupler();
}

module Stepped_Taper_Adapter() {
    P1_ID_Tip  = Port_1_OD_Tip - 2 * Wall_Thickness;
    P1_ID_Base = Port_1_OD_Base - 2 * Wall_Thickness;
    P2_OD_Tip  = Port_2_ID_Tip + 2 * Wall_Thickness;
    P2_OD_Base = Port_2_ID_Base + 2 * Wall_Thickness;

    difference() {
        union() {
            cylinder(d1=Port_1_OD_Tip, d2=Port_1_OD_Base, h=Port_1_Length);
            translate([0, 0, Port_1_Length])
                cylinder(d1=Port_1_OD_Base, d2=P2_OD_Base, h=Transition_Length);
            translate([0, 0, Port_1_Length + Transition_Length])
                cylinder(d1=P2_OD_Base, d2=P2_OD_Tip, h=Port_2_Length);
        }
        translate([0, 0, -1])
            cylinder(d1=P1_ID_Tip, d2=P1_ID_Base, h=Port_1_Length + 1.1);
        translate([0, 0, Port_1_Length])
            cylinder(d1=P1_ID_Base, d2=Port_2_ID_Base, h=Transition_Length);
        translate([0, 0, Port_1_Length + Transition_Length])
            cylinder(d1=Port_2_ID_Base, d2=Port_2_ID_Tip, h=Port_2_Length + 2);

        // Stamped Port labels
        translate([0, Port_1_OD_Base / 2 - 0.2, Port_1_Length + Transition_Length / 2])
            rotate([90, 0, 0])
            linear_extrude(0.6)
            text(str(Port_1_Label, " -> ", Port_2_Label), size=2.8, halign="center", valign="center", font="Liberation Sans:style=Bold");
    }
}

module Magnetic_Dust_Lock_Flange() {
    Flange_OD = Port_1_OD_Base + 30.0;
    Flange_H  = 12.0;
    Bolt_Circle_D = (Flange_OD + Port_1_OD_Base) / 2;

    difference() {
        union() {
            cylinder(d=Flange_OD, h=Flange_H);
            translate([0, 0, Flange_H])
                cylinder(d=Port_1_OD_Base, h=Port_1_Length);
        }
        translate([0, 0, -1])
            cylinder(d=Port_1_OD_Base - 2 * Wall_Thickness, h=Flange_H + Port_1_Length + 2);

        // Circular magnet array
        for (i = [0 : Magnet_Count - 1]) {
            rotate([0, 0, i * (360 / Magnet_Count)])
                translate([Bolt_Circle_D / 2, 0, -0.1])
                cylinder(d=Magnet_Hole_Dia, h=Magnet_Hole_Depth);
        }

        // O-Ring Gasket groove
        difference() {
            cylinder(d=O_Ring_Groove_D + 3, h=2.0);
            translate([0, 0, -0.5]) cylinder(d=O_Ring_Groove_D, h=3.0);
        }
    }
}

module Twist_Bayonet_Coupler() {
    difference() {
        union() {
            cylinder(d=38.0, h=35.0);
            // Bayonet locking lugs
            translate([0, 0, 18.0]) rotate([0, 90, 0]) cylinder(d=4.0, h=44.0, center=true);
        }
        translate([0, 0, -1]) cylinder(d=27.0, h=37.0);
    }
}
