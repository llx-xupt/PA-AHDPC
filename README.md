# PA-AHDPC: Physics-Aware Adaptive Hyperbolic Density Peak Clustering for Infrared Small Target Detection

[![MATLAB](https://img.shields.io/badge/MATLAB-R2024b-blue.svg)](https://www.mathworks.com/products/matlab.html)
[![License: MIT](https://img.shields.io/badge/License-MIT-green.svg)](https://opensource.org/licenses/MIT)
[![Journal](https://img.shields.io/badge/Under_Review-Infrared_Physics_&_Technology-orange.svg)]()

> [cite_start]This repository contains the official MATLAB implementation of the paper **"Infrared Small Target Detection via Adaptive Hyperbolic Density Peak Clustering and Physics-Driven Verification"**[cite: 1320, 1321]. 

[cite_start]**Authors:** Chengmao Wu, Longxin Liu [cite: 1322]  
[cite_start]**Institution:** School of Electronic Engineering, Xi'an University of Posts and Telecommunications, Xi'an, PR China [cite: 1323]

---

## 📖 Introduction

[cite_start]In complex infrared scenes with extremely low signal-to-clutter ratios (SCR), traditional detection algorithms suffer from a severe "feature crowding effect" when mapping hierarchical background clutter into a flat Euclidean space[cite: 1368]. 

[cite_start]To break through this theoretical bottleneck, we propose **PA-AHDPC**, a novel training-free detection paradigm that integrates non-Euclidean geometric reconstruction with optical mechanism verification[cite: 1369]. [cite_start]By leveraging the exponential expansion property of the hyperbolic Poincaré ball and the energy diffusion prior of the point spread function (PSF), our method successfully separates weak targets from strong structured clutter and high-brightness sensor dead pixels[cite: 1371, 1372, 1373, 1374].

### ✨ Highlights
* [cite_start]**Hyperbolic Manifold Mapping:** Pioneered a novel Poincaré ball paradigm to fundamentally resolve the feature crowding effect via the exponential spatial expansion of non-Euclidean manifolds[cite: 1316, 1317].
* [cite_start]**AHDPC Algorithm:** Developed Adaptive Hyperbolic Density Peak Clustering with tangent-space anisotropic covariance correction for robust target isolation[cite: 1318].
* [cite_start]**Strict-LGD Verification:** Integrated a physics-driven soft-decision mechanism based on PSF priors with energy spillover tolerance to eliminate pseudo-targets (e.g., dead pixels)[cite: 1319, 1373, 1374].
* [cite_start]**Exceptional Robustness:** Outperforms the second-best SOTA algorithms by 5-10 dB in Signal-to-Clutter Ratio Gain (SCRG) and maintains a high AUC (> 0.93) even under extreme high-frequency noise ($\sigma=15$)[cite: 1376, 1377].

---

## 🚀 Overall Framework

[cite_start]Our PA-AHDPC framework consists of three tightly coupled stages[cite: 1636]:

1. [cite_start]**Stage 1: Dual-prior Probabilistic Screening:** Fuses Local Homogeneity Index (LHI) and multiscale Tri-layer Local Contrast Measure (TLLCM) to generate candidate patches efficiently[cite: 1330, 1659, 1660].
2. [cite_start]**Stage 2: Adaptive Hyperbolic Manifold Clustering:** Projects candidate features into the Poincaré ball and utilizes tangent-space covariance for anisotropic correction and robust core segmentation[cite: 1334, 1664, 1665, 1666].
3. [cite_start]**Stage 3: Strict-LGD Physical Verification:** Constructs a multi-layer gradient soft-decision logic based on the target's PSF energy diffusion to verify physical conformity[cite: 1350, 1670, 1671].

*(Note: You can insert your flowchart image here by uploading `flowchart.png` to your repo and using `![Framework](flowchart.png)`)*

---

## 📂 Project Structure

```text
Infrared-Target-Detection/
├── demo.m                       # Main execution script for quick start
├── README.md                    # Project documentation
├── LICENSE                      # MIT License
├── .gitignore                   # Ignored files for clean repo
├── src/                         # Core algorithm functions
│   ├── infrared_target_detection.m
│   ├── compute_adaptive_hyperbolic_distance.m
│   ├── compute_LHI.m
│   ├── compute_LGD_strictly_paper.m
│   └── ... 
└── test_images/                 # Sample infrared images for testing
    ├── test1.png
    ├── test2.png
    └── test3.png
