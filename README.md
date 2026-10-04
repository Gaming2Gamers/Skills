# 🎮 Gaming2Gamers: The Universal AI Skill Tree

> **The universal skill tree for Gemini, Claude, ChatGPT, and local AI agents.**  
> *Equip legendary crafting abilities, unlock physical robotics questlines, and level up your AI companion to Lv.99 Master Artificer.* ⚔️✨

[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)](LICENSE)
[![Compatible: Gemini](https://img.shields.io/badge/Google_Gemini-Skills_Ready-4285F4?logo=google-gemini)](https://ai.google.dev/)
[![Compatible: Claude](https://img.shields.io/badge/Anthropic_Claude-Projects_&_Code-D97706?logo=anthropic)](https://claude.ai/)
[![Compatible: OpenAI](https://img.shields.io/badge/OpenAI_ChatGPT-Custom_GPT-10A37F?logo=openai)](https://chatgpt.com/)
[![Craftsmanship: Bespoke](https://img.shields.io/badge/Craftsmanship-Bespoke_∞_Meraki-9333EA)](#)

---

## 🎒 The Active Skill Tree

| Skill Icon | Skill Identifier | Category | Class Tier | Package Download |
|---|---|---|---|---|
| 🛠️ | **`@three-d-printer`** | Parametric CAD & 3D Printing | **Master Artificer (Epic)** | [Download `3dprinter.zip`](packages/3dprinter.zip) |
| 🦾 | **`@openarm`** | 7-DOF Kinematics & CAN Bus | *Legendary (Coming Soon)* | *In Development* |
| 🤖 | **`@companion`** | Somatic Companion & Wetware | *Mythic (Coming Soon)* | *In Development* |

---

## 🛠️ Featured Skill: `3dprinter` (v2.1.0)

Turn your AI model into a master parametric mechanical engineer that writes mathematically verified, print-ready **OpenSCAD** code.

### 🧠 Mandatory Cognitive Directive
> [!IMPORTANT]
> **To the User & Assistant:** OpenSCAD parametric geometry, CSG boolean operations, radial fillets, internal wall clearances, print-in-place tolerances, living hinge flexures, and snap-fit cantilevers require non-linear spatial reasoning across multiple geometric constraints simultaneously.
> 
> 👉 **Always verify that "Deep Think" or "Extended Thinking" is switched ON (`ThinkingLevel.HIGH`) on your AI model before generating OpenSCAD geometry!**

### ✨ Key Features
- **12 Specialized Parametric Engines:** Enclosures, adapters/ducts, robotics links, living hinges, TPU gaskets, Gridfinity bins, GT2 timing pulleys, battery sleds, phone cases, fluted knobs, workshop drill jigs, and organic jewelry.
- **82 Manufacturer CAD Models:** Complete geometric library of authentic components (`.stl` + `.step`) including cheap Amazon STEM servos (TowerPro SG90, MG996R, DS3225 25kg), 28BYJ-48 geared steppers, PCA9685 16-channel servo drivers, ESP32 DevKit, Arduino Nano, Raspberry Pi Pico, HC-SR04 ultrasonic eyes, dual 18650 sleds, and 65mm robot wheels.
- **Empirical DfAM Tolerances:** Built-in standard clearance standards (Press $-0.10\text{mm}$, Snug $+0.05\text{mm}$, Sliding $+0.15\text{mm}$, Free $+0.35\text{mm}$), $0.20\text{mm}$ radial crush ribs, PLA viscoelastic creep compensation, and TPU flexure formulas.
- **OrcaSlicer Production Calibration:** 6-perimeter watertight law, sandwich inner-outer-inner walls, and 20mm scarf joint seam hiding.
- **Physical Part Traceability:** Automatic embossed part numbers (`Project_Part_Label`) and `∞ Meraki` hallmark stamps.
- **Interactive WebGL 3D Previewer:** Standalone Three.js canvas (`templates/webgl_3d_canvas_preview.html`) with interactive dimension sliders, color toggles, and live STL dropzone.

---

## 🕹️ How to Equip Skills

### 🔵 Google Gemini (Native 1-Click Upload)
1. Download [`packages/3dprinter.zip`](packages/3dprinter.zip).
2. Open **Gemini Advanced** -> **Settings / Skills** -> Click **Upload Skill**.
3. Select `3dprinter.zip`.
4. In your prompt, tag **`@three-d-printer`** and turn on **Deep Think / Extended Thinking**!

### 🟠 Anthropic Claude (Claude Projects & Claude Code)
* **Claude Projects:** Drag and drop `skills/three-d-printer/SKILL.md`, `skills/three-d-printer/cad_library/manifest.json`, and the `.scad` templates into your Project Knowledge.
* **Claude Code:** Copy `skills/three-d-printer` into your project's `.claude/skills/` directory.

### 🟢 OpenAI ChatGPT (Custom GPTs)
1. Go to **Explore GPTs** -> **Create a GPT**.
2. Paste the contents of `skills/three-d-printer/SKILL.md` into **Instructions**.
3. Upload `skills/three-d-printer/cad_library/manifest.json` and the template files to **Knowledge**.
4. Set model to **o1**, **o3-mini (High Reasoning)**, or **GPT-4o**.

### 💻 IDE & Local Agents (Cursor, Windsurf, DeepSeek-R1, Ollama)
* **Cursor / Windsurf:** Add `skills/three-d-printer/SKILL.md` to your `.cursorrules` or `.windsurfrules`.
* **Local Models:** Pass `SKILL.md` as the system prompt to **DeepSeek-R1** or **Qwen 2.5 Coder 32B**.

---

## 📜 Repository Structure

```text
Skills/
├── .gitignore
├── LICENSE
├── README.md
├── packages/
│   └── 3dprinter.zip                     # Pre-packaged 1-click install (40.12 MB)
└── skills/
    └── three-d-printer/
        ├── SKILL.md                      # Canonical skill instructions & prompt
        ├── README.md                     # Skill documentation
        ├── dfam_tolerance_and_mechanisms.json # Engineering clearance database
        ├── cad_library/
        │   ├── manifest.json             # 82-item CAD component catalog
        │   ├── actuators/                # Servos (SG90, MG996R, DS3225), steppers, motors
        │   ├── batteries/                # 18650 sleds, LiPo packs
        │   ├── boards/                   # ESP32, Arduino Nano, Pico, PCA9685
        │   ├── displays/                 # TFTs, OLEDs, NeoPixel rings
        │   ├── gridfinity/               # Standard Zack Freedman bins
        │   ├── hardware/                 # 2020 extrusion, buttons, jacks
        │   ├── robotics/                 # OpenArm links, TT wheels, pan-tilts
        │   └── sensors/                  # HC-SR04 ultrasonic, BME280, IMUs
        └── templates/
            ├── webgl_3d_canvas_preview.html # 3D Three.js interactive preview
            ├── enclosure_engine.scad     # Snap-fit & heat-set enclosures
            ├── robotics_projects_engine.scad # STEM arms, rovers, pan-tilts
            ├── household_utility_engine.scad # Squeezers, clips, cord wraps
            └── ... (9 additional OpenSCAD engines)
```

---

## 🤝 Contributing & Meraki Standard

All skills submitted to this repository must be **bespoke** and follow the **Meraki Engineering Standard**:
1. Zero empty boilerplate or non-manifold geometry.
2. Verified physical clearances (must specify DfAM tolerances).
3. Open source CAD assets with accurate dimensions.

---

## ⚖️ License
Released under the [MIT License](LICENSE). Built with **∞ Meraki** by [Gaming2Gamers](https://gaming2gamers.com).
