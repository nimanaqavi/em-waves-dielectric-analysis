# Fields and Waves Simulation Project

## Project Description

This repository holds a two-part electromagnetic engineering project. The project uses CST Studio Suite for simulation and MATLAB for analysis. The project also includes a full LaTeX report in Persian.

**Part 1: Half-Wavelength Dielectric Impedance Transformer.**
This part analyzes a half-wavelength impedance transformer. The transformer uses a Plexiglass dielectric layer. The center design frequency is 65 GHz. The relative permittivity of the material is 2.6. The loss tangent of the material is 0.009. The report compares theory and simulation for the reflection coefficient (S11) and the transmission coefficient (S21).

**Part 2: Skin Depth in a Lossy Dielectric.**
This part analyzes the penetration depth of a wave in a lossy dielectric material. The relative permittivity of the material is 9. The loss tangent of the material is 0.17. The center frequency is 62 GHz. The report compares theory and simulation for the attenuation of the wave.

## Repository Structure

```
├── main.tex                # Main LaTeX source file of the report
├── Settings.tex             # LaTeX package and font settings (XePersian)
├── titlepage.tex            # LaTeX title page source
├── main.pdf                 # Compiled final report (Persian)
│
├── FW_HW1_Q1.m               # MATLAB script for Part 1 (impedance transformer)
├── FW_HW1_Q2.m               # MATLAB script for Part 2 (skin depth)
│
├── PJ1_55Ghz.gif             # Field animation, Part 1, band-start frequency (55 GHz)
├── PJ1_65Ghz.gif             # Field animation, Part 1, center frequency (65 GHz)
├── PJ1_75Ghz.gif             # Field animation, Part 1, band-end frequency (75 GHz)
├── PJ2_52Ghz.gif             # Field animation, Part 2, band-start frequency (52 GHz)
├── PJ2_62Ghz.gif             # Field animation, Part 2, center frequency (62 GHz)
├── PJ2_72Ghz.gif             # Field animation, Part 2, band-end frequency (72 GHz)
│
└── README.md                 # This file
```

Note: The CST model files and the raw `.txt` export files (S11, S21, and depth data) are not listed above. Add these files to the repository in a `data/` folder if you want to re-run the MATLAB scripts.

## Theory and Simulation Methodology

### Part 1 — Half-Wavelength Dielectric Impedance Transformer

The half-wave window is a known method in microwave engineering. A dielectric layer with a thickness equal to half a wavelength gives an input impedance equal to the output impedance. The wave passes through the layer with no reflection. This method is useful for radome design. A radome is a mechanical cover for an antenna. The radome must not add reflection loss.

The layer thickness follows this equation:

```
d = c / (2 × fc × sqrt(εr))
```

For Plexiglass at 65 GHz, the thickness is about 1.41 mm.

**Simulation setup in CST:**
1. The project uses the Unit Cell method. This method models an infinite dielectric sheet with a small periodic cell.
2. The project applies a Periodic Boundary Condition on all four side faces (X and Y directions).
3. The project defines the Zmin and Zmax faces as Floquet ports. These ports excite and receive a normal-incidence TEM plane wave. Higher-order Floquet modes stay evanescent.
4. The simulation runs over a 30% bandwidth around the 65 GHz center frequency.
5. The MATLAB script `FW_HW1_Q1.m` reads the CST S-parameter export files. The script computes the theoretical S11 and S21 curves with a three-medium transmission-line model. The script plots the theory curve against the simulation curve.

### Part 2 — Skin Depth in a Lossy Dielectric

When a wave enters a lossy medium, the wave amplitude decays with depth. The decay follows an exponential law:

```
E(z) = E0 × exp(−αz)
```

Here, α is the attenuation constant. The skin depth (δ) is the depth where the field amplitude drops to 1/e (about 37%) of its value at the boundary. The skin depth is the inverse of the attenuation constant:

```
δ = 1 / α
```

**Simulation setup in CST:**

A rectangular waveguide with PEC walls does not produce a pure TEM wave. A rectangular PEC waveguide has a cutoff frequency and a non-uniform field pattern. The project avoids this problem with a combination of two boundary types on the side walls.

- **Electric boundary (PEC, Et = 0):** The project sets this boundary on two opposite side faces (the X faces). This boundary forces the tangential electric field to zero on these faces. The electric field can only exist normal to these walls.
- **Magnetic boundary (PMC, Ht = 0):** The project sets this boundary on the other two opposite side faces (the Y faces). This boundary forces the tangential magnetic field to zero on these faces. The magnetic field can only exist normal to these walls.

Together, these two boundary types force the electric field to point only along X and the magnetic field to point only along Y. This condition matches a uniform TEM plane wave that travels along Z. This setup acts like an open parallel-plate waveguide. This waveguide has no cutoff frequency, unlike a full-PEC rectangular waveguide.

The Zmin and Zmax faces (the direction of propagation) use Open boundaries with Waveguide Port excitation. This setup lets the wave enter and exit without artificial reflection.

**Skin depth measurement procedure (two-probe method):**

The procedure does not fit a full exponential curve to the field profile. Instead, the procedure uses two field probes:
1. Probe 1 (z1) sits exactly at the dielectric boundary.
2. Probe 2 (z2) sits 1 mm inside the lossy material (Δz = 1 mm).

The field amplitude in a homogeneous lossy medium follows the exponential law |E(z)| = |E0| × exp(−αz). The ratio of the two probe readings gives the local attenuation constant directly. The CST Template Based Post-Processing tool computes the skin depth across the full frequency band with this equation:

```
δ = Δz / ln(|E1| / |E2|)
```

The MATLAB script `FW_HW1_Q2.m` reads the CST S11, S21, and skin depth export files. The script computes the theoretical S11, S21, and skin depth curves. The script plots the theory curves against the simulation curves.

## Simulation Results

### Part 1 — Impedance Transformer (Plexiglass, fc = 65 GHz)

| Result | Description |
|---|---|
| ![S11 comparison](placeholder-s11-part1.png) | Reflection coefficient (S11): theory vs. CST simulation |
| ![S21 comparison](placeholder-s21-part1.png) | Transmission coefficient (S21): theory vs. CST simulation |
| ![E-field at 55 GHz](PJ1_55Ghz.gif) | Field distribution at the band-start frequency (55 GHz) |
| ![E-field at 65 GHz](PJ1_65Ghz.gif) | Field distribution at the center frequency (65 GHz) |
| ![E-field at 75 GHz](PJ1_75Ghz.gif) | Field distribution at the band-end frequency (75 GHz) |

### Part 2 — Skin Depth (εr = 9, tan δ = 0.17, fc = 62 GHz)

| Result | Description |
|---|---|
| ![S11 comparison](placeholder-s11-part2.png) | Reflection coefficient (S11): theory vs. CST simulation |
| ![S21 comparison](placeholder-s21-part2.png) | Transmission coefficient (S21): theory vs. CST simulation |
| ![Skin depth comparison](placeholder-skin-depth.png) | Skin depth (δ) vs. frequency: theory vs. CST simulation |
| ![E-field at 52 GHz](PJ2_52Ghz.gif) | Field attenuation at the band-start frequency (52 GHz) |
| ![E-field at 62 GHz](PJ2_62Ghz.gif) | Field attenuation at the center frequency (62 GHz) |
| ![E-field at 72 GHz](PJ2_72Ghz.gif) | Field attenuation at the band-end frequency (72 GHz) |

The report (`main.pdf`) shows the full result plots and field distribution figures.

## How to Run

1. Open the CST model files in CST Studio Suite. Run the frequency-domain solver over the 30% bandwidth for each part.
2. Export the S11 and S21 results as `.txt` files. For Part 2, also export the skin depth result as a `.txt` file.
3. Place the exported `.txt` files in the MATLAB working folder.
4. Open `FW_HW1_Q1.m` in MATLAB for Part 1. Run the script. The script produces two figures: S11 and S21.
5. Open `FW_HW1_Q2.m` in MATLAB for Part 2. Run the script. The script produces three figures: S11, S21, and skin depth.
6. Compile `main.tex` with XeLaTeX to build the full report. The report uses the XePersian package. The report needs the required Persian fonts on the build system.
