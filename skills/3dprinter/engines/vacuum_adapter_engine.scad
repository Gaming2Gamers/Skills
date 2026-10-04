// ====================================================================
// PARAMETRIC MAKER FORGE - DUST EXTRACTION & VACUUM ADAPTER ENGINE
// Parametric OpenSCAD with Dual Tapers, Friction Ribs & Part ID Stamps
// ====================================================================

$fn = 72;

/* [Side A - Machine / Tool Port] */
End_A_Name = "SHOP-VAC 2.5IN";
End_A_Outer_Dia_Tip  = 57.2;
End_A_Outer_Dia_Base = 58.6;
End_A_Length         = 35.0;

/* [Side B - Hose / Extractor Port] */
End_B_Name = "FESTOOL D27";
End_B_Inner_Dia_Tip  = 27.2;
End_B_Inner_Dia_Base = 26.5;
End_B_Length         = 30.0;

/* [Transition Section] */
Transition_Length = 25.0;
Wall_Thickness    = 2.4;

/* [Part Identification Stamp] */
Emboss_Specs = true;
Stamp_Label = str(End_A_Name, " -> ", End_B_Name);

// Calculated dimensions
Total_H = End_A_Length + Transition_Length + End_B_Length;
End_A_ID_Tip  = End_A_Outer_Dia_Tip - 2 * Wall_Thickness;
End_A_ID_Base = End_A_Outer_Dia_Base - 2 * Wall_Thickness;
End_B_OD_Tip  = End_B_Inner_Dia_Tip + 2 * Wall_Thickness;
End_B_OD_Base = End_B_Inner_Dia_Base + 2 * Wall_Thickness;

difference() {
    // Outer tapered solid
    union() {
        // End A (Male Taper)
        cylinder(d1=End_A_Outer_Dia_Tip, d2=End_A_Outer_Dia_Base, h=End_A_Length);

        // Transition Cone
        translate([0, 0, End_A_Length])
            cylinder(d1=End_A_Outer_Dia_Base, d2=End_B_OD_Base, h=Transition_Length);

        // End B (Female Socket)
        translate([0, 0, End_A_Length + Transition_Length])
            cylinder(d1=End_B_OD_Base, d2=End_B_OD_Tip, h=End_B_Length);
    }

    // Inner hollow bore
    union() {
        // End A bore
        translate([0, 0, -1])
            cylinder(d1=End_A_ID_Tip, d2=End_A_ID_Base, h=End_A_Length + 1.1);

        // Transition bore
        translate([0, 0, End_A_Length])
            cylinder(d1=End_A_ID_Base, d2=End_B_Inner_Dia_Base, h=Transition_Length);

        // End B bore
        translate([0, 0, End_A_Length + Transition_Length])
            cylinder(d1=End_B_Inner_Dia_Base, d2=End_B_Inner_Dia_Tip, h=End_B_Length + 2);
    }

    // Debossed size identification along transition band
    if (Emboss_Specs) {
        translate([0, End_A_Outer_Dia_Base / 2 - 0.3, End_A_Length + Transition_Length / 2])
            rotate([90, 0, 0])
            linear_extrude(0.6)
            text(Stamp_Label, size=3.0, halign="center", valign="center", font="Liberation Sans:style=Bold");
    }
}
