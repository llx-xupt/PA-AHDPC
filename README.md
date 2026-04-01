# PA-AHDPC: Physics-Aware Adaptive Hyperbolic Density Peak Clustering

[![MATLAB](https://img.shields.io/badge/MATLAB-R2024b-blue.svg)](https://www.mathworks.com/products/matlab.html)
[![License: MIT](https://img.shields.io/badge/License-MIT-green.svg)](https://opensource.org/licenses/MIT)
[![Status: Submitted](https://img.shields.io/badge/Status-Under_Review-orange.svg)]()

Official MATLAB implementation of the paper **"New infrared small target detection based on adaptive hyperbolic density clustering and physics-driven verification"** (Submitted to *Infrared Physics & Technology*).

## 📖 Overview

In complex infrared scenes with extremely low signal-to-clutter ratios (SCR), existing detection algorithms suffer from a severe "feature crowding effect" due to the geometric mismatch between spatial capacity and data structure in Euclidean space. 

This repository provides the code for **PA-AHDPC**, a novel training-free detection paradigm that integrates non-Euclidean geometric reconstruction with optical mechanism verification. The framework completely abandons flat Euclidean geometry in favor of a hyperbolic Poincaré ball model, effectively decoupling weak targets from massive structural clutter.

### 🌟 Key Highlights

1. **Dual-prior Probabilistic Screening:** Rapidly anchors high-confidence candidate regions using Local Homogeneity Index (LHI) and multiscale Tri-Layer Local Contrast Measure (TLLCM) combined with a highly efficient H-MDPS algorithm.
2. **Adaptive Hyperbolic Manifold Clustering:** Maps features into a Poincaré ball with negative curvature. Combined with tangent-space anisotropic covariance correction, it effectively isolates weak targets from structured clutter by leveraging the exponential expansion property of hyperbolic space.
3. **Physics-Driven Soft-Decision Verification (Strict-LGD):** Employs an energy spillover tolerance mechanism based on Point Spread Function (PSF) priors to filter out pseudo-targets (e.g., highly bright sensor dead pixels) lacking continuous energy diffusion.

## 📁 Repository Structure

The repository is organized as follows:

```text
Infrared-Target-Detection/
├── demo.m                                  % Main executable script for a quick demo
├── src/                                    % Core algorithm implementations
│   ├── compute_adaptive_hyperbolic_distance.m
│   ├── compute_LGD_strictly_paper.m        % Stage 3: Strict-LGD Soft-Decision
│   ├── compute_LHI.m                       % Stage 1: LHI extraction
│   ├── compute_TLLCM_vectorized.m          % Stage 1: TLLCM structural prior
│   ├── create_surround_masks.m
│   ├── extract_candidates_MDPS_strict.m    % Stage 1: H-MDPS Algorithm
│   ├── infrared_target_detection.m         % Main pipeline wrapper
│   ├── map_to_tangent_space.m              
│   ├── mobius_addition.m                   % Möbius gyrovector operations
│   ├── process_candidates_ahdpc.m          % Stage 2: AHDPC clustering
│   ├── run_ahdpc_clustering.m
│   └── shift_matrix_replicate.m
└── test_images/                            % Sample challenging infrared scenarios
    ├── test1.png
    ├── test2.png
    └── test3.png
