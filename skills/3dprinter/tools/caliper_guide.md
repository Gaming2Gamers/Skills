# 📐 The Rapid Caliper & CAD Discovery Guide

If your board, sensor, or tool is not in the built-in database, use these 3 simple methods to grab exact dimensions in under 60 seconds.

---

### Method 1: The 4-Measurement Caliper Protocol

Grab a digital caliper (or metric ruler) and measure these 4 dimensions:

```
          ┌─────────────────────── W ───────────────────────┐
          │                                                 │
          │     (Hole 1)                     (Hole 2)       │
          │        ⊕ ─────── dx_spacing ─────── ⊕           │
          │        │                            │           │
       L  │    dy_spacing                   dy_spacing      │
          │        │                            │           │
          │        ⊕ ────────────────────────── ⊕           │
          │     (Hole 4)                     (Hole 3)       │
          │                                                 │
          └─────────────────────────────────────────────────┘
```

1. **Overall Width ($W$) & Length ($L$)**: Measure total outer PCB dimensions in mm.
2. **Mounting Hole Spacing ($dx, dy$)**:
   - *Caliper Pro-Tip*: Don't try to guess the center of the holes!
   - Measure from the **left edge of Hole 1 to the left edge of Hole 2**. Because both holes are the same size, this equals the exact center-to-center distance $dx$!
3. **Corner Offset ($ox, oy$)**: Measure from the outer edge of the PCB to the center of Hole 1.
4. **Hole Diameter ($d$)**: Measure the inside diameter of the mounting hole (usually 2.5mm, 3.0mm, or 3.2mm).

---

### Method 2: Instant Online Search Formulations

Copy-paste these exact search formulas into Google or GitHub to find official engineering drawings, STEP files, or DXFs:

- **Mechanical Drawing PDF**: `"[Your Device Model]" ("mechanical dimensions" OR "dimension drawing" OR "datasheet") filetype:pdf`
- **EasyEDA / LCSC 3D Models**: `"[Your Device Model]" site:easyeda.com OR site:oshwlab.com 3D model`
- **GrabCAD / Printables STEP**: `"[Your Device Model]" (step OR stp OR cad) site:grabcad.com OR site:printables.com`
- **GitHub Hardware Repositories**: `"[Your Device Model]" (kicad OR eagle OR dxf OR hardware) site:github.com`

---

### Method 3: The Flatbed Scanner / Orthogonal Photo Trick

1. Place your board on a flatbed office scanner or on a sheet of 5mm graph paper with a coin or ruler next to it.
2. Scan at 300 or 600 DPI (or take a photo from directly above without perspective tilt).
3. Open the image in any image viewer or CAD software:
   - Count pixels per millimeter from the ruler.
   - You can measure every port offset and hole coordinate down to 0.1mm!
