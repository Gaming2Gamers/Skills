# 🛠️ 3dprinter (Gemini Skill & OpenSCAD Suite)
### *Crafted with ∞ Meraki — Modern Alchemy in Plastic & Metal*

> **Bespoke 3D Printing, Parametric CAD & Robotics Kit Assistant with Part ID Traceability**  
> Designed for Google Gemini Skills, OpenSCAD, Printables, and maker classrooms worldwide.

---

## 🌟 The Meraki Manifesto

In ancient Greek, **Meraki (μεράκι)** means pouring your soul, creativity, and love into everything you create; putting a piece of yourself into your work. 

3D printing is not about filling the world with throwaway plastic trinkets. It is **digital blacksmithing**. It is taking an abstract thought in your mind, turning it into mathematical code, and forging a physical, functional object in the real world. 

Whether you are a parent or educator building a **$25 4-DOF robot arm with your kids using cheap Amazon micro servos**, or an engineer machining a **7-DOF kinematic link with CAN actuators and cycloidal reducers**, Maker Forge stamps every model with bespoke precision, physical Part ID traceability, and the proud mark of **∞ Meraki**.

---

## 🚀 Key Capabilities

1. **🤖 Full Robotics Project Kits (Kids STEM to Pro Robotics)**:
   - **Kids STEM Mini-Arm (Under $25)**: 4-axis desktop robot arm powered by cheap $1.50 Amazon micro servos (SG90/MG90S) with snap-fit horn capture pockets (fits the free white horns in the bag!).
   - **Kids Autonomous Obstacle Rover (Under $30)**: Dual yellow TT motor chassis with sweeping ultrasonic radar eye on an SG90 neck.
   - **Pro 7-DOF OpenArm Kinematic Link**: Heavy-duty joint links with dual bearing carriers and internal CAN bus wire conduits.
   - **2-DOF Somatic Head & Sensor Turret**: Expressive animatronic neck assembly for stereo vision (Intel RealSense / RPi Cam 3).
   - **Desktop AI Companion Pod (Gemma Mini)**: Cyberpunk desktop robot casing with 4.0" touchscreen visor and acoustic speaker chamber.

2. **🏠 Household Utility & 🖨️ 3D Printer Enclosure Mods**:
   - **Print-In-Place Foldable Phone Stand**: 13-gram compliant hinge design with dual landscape/portrait viewing angles and cable relief.
   - **LastDrop Tube Roller Squeezer**: Slotted core spindle with knurled thumb dial for toothpaste, cosmetic, and oil paint tubes.
   - **Dual-Chamber Self-Watering Planter**: Watertight reservoir with capillary wick column for sub-irrigation.
   - **Under-Desk Headphone Hanger**: 45° load-bearing gusset designed in PETG to eliminate cold creep sag.
   - **CoreXY TPU Anti-Vibration Foot**: Hollow energy dissipation cup reducing frame resonance and ghosting.
   - **CoreXY Purge Chute Deflector**: 38° steep non-stick deflector preventing purge blob buildup.

3. **Physical Part ID & Traceability Debossing**:
   - Automatically debosses the **Part ID**, hardware model, screw sizes (`M3x4.0 Ruthex`), and port labels directly into the printed plastic.
   - Never confuse which printed box fits which board or which screw goes where on your workbench!

4. **Exhaustive CAD Dimension & DfAM Datasets**:
   - Verified sub-millimeter hole offsets, keepouts, and connector positions for Raspberry Pi (5, 4, Zero), ESP32 (30P, 38P, S3), Arduino (Uno, Mega, Nano), BigTreeTech, NEMA 17/23 steppers, SG90/MG996R servos, Milwaukee/DeWalt battery docks, and Festool/Shop-Vac hoses.
   - **Empirical DfAM Tolerances**: Press fit ($-0.10\text{mm}$), Snug fit ($+0.05\text{mm}$), Sliding fit ($+0.15\text{mm}$), Free fit ($+0.35\text{mm}$), and $0.20\text{mm}$ radial crush ribs.

5. **🏛️ Authentic Manufacturer CAD Library (69+ Verified Models)**:
   - Contains authentic 3D models harvested directly from official manufacturers (Raspberry Pi Foundation, Adafruit Industries, Bosch, STMicroelectronics, Omron, Voron Design, OpenArm, and Zack Freedman).
   - Includes genuine binary `.stl` and mechanical `.step` files for Raspberry Pi 5, Compute Module 5, Pico, Pico W, Arduino Uno (Metro 328), Feather ESP32-S3, BME280, VL53L1X LiDAR, SG90 servos, NEMA 17 steppers, 608 bearings, Ruthex M3 inserts, 9V batteries, 18650 cells, and full 7-DOF OpenArm joints!
   - Visualized in real-time inside the WebGL 3D previewer so you can physically check part fit and port alignment before printing!

6. **Fallback Discovery Toolkit (For Unlisted Parts)**:
   - **4-Measurement Caliper Protocol**: Step-by-step guide to measure any PCB in under 60 seconds without guessing hole centers.
   - **Automated Search Formulator**: Instant search strings for GrabCAD, EasyEDA, and manufacturer PDFs.
   - **3-Minute Fit-Check Coupon**: Print a 1-gram micro test coupon in 3 minutes to test screw hole shrinkage and snap-fit flex before committing to a full print.

7. **Native OpenSCAD Customizer & Deep Think Mandate**:
   - Requires **Deep Think / Extended Thinking** (`ThinkingLevel.HIGH`) on Gemini to ensure error-free 3D CSG boolean geometry and compliant living hinges.
   - Every generated `.scad` script features `/* [Parameters] */` headers that automatically render interactive sliders, dropdowns, and toggles in OpenSCAD and Printables!

8. **Canvas 3D WebGL Configurator & CAD Inspector**:
   - Interactive Three.js 3D viewer for Gemini Canvas with real-time exploded view slider, live dimension previews, authentic manufacturer CAD model inspection, and drag-and-drop STL verification.

---

## 📦 How to Install in Google Gemini Skills

1. Download **`3dprinter.zip`** from this repository.
2. Open [Gemini](https://gemini.google.com) on your computer or mobile app.
3. Go to **Settings -> Skills** (or visit `https://support.google.com/gemini/answer/17094296`).
4. Click **"Upload a file or folder to create a skill"** and select `3dprinter.zip`.
5. Name it **"3dprinter"** and click Save!
6. Now, whenever you tag `@3dprinter` or say *"Help me design a 3D printed enclosure"* or *"I need a vacuum adapter for my shop vac"*, Gemini will automatically launch 3dprinter with interactive intake, Part ID matching, and parametric OpenSCAD generation!

---

## 🖨️ Slicer Quick-Start Settings (OrcaSlicer & Flashforge)

- **Layer Height**: `0.20mm` (Standard Quality)
- **Walls / Perimeters**: `6` solid perimeters (The 6-Perimeter Law: far superior flexural strength vs high infill!)
- **Infill**: `20% - 25% Gyroid` (Provides uniform isotropic strength)
- **Scarf Seams**: Enable `20mm` scarf joint seams to eliminate Z-seams on round cylinders.
- **Wall Ordering**: `Sandwich Mode` (Inner-Outer-Inner) for $\pm 0.04\text{mm}$ dimensional precision.
- **Top / Bottom Layers**: `4` Top / `4` Bottom
- **Supports**: **None!** (All Maker Forge models are designed to print support-free flat on the build plate)
