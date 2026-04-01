# PA-AHDPC: Physics-Aware Adaptive Hyperbolic Density Peak Clustering

[![MATLAB](https://img.shields.io/badge/MATLAB-R2024b-blue.svg)](https://www.mathworks.com/products/matlab.html)
[![License: MIT](https://img.shields.io/badge/License-MIT-green.svg)](https://opensource.org/licenses/MIT)

Official MATLAB implementation of the paper **"New infrared small target detection based on adaptive hyperbolic density clustering and physics-driven verification"** by Zhuo Zhu, Longxin Liu, and Chengmao Wu.

## 📖 Overview

In complex infrared scenes with extremely low signal-to-clutter ratios (SCR), existing detection algorithms suffer from a severe "feature crowding effect" due to the geometric mismatch between spatial capacity and data structure in Euclidean space. 

This repository provides the code for **PA-AHDPC**, a novel training-free detection paradigm that integrates non-Euclidean geometric reconstruction with optical mechanism verification. The framework completely abandons flat Euclidean geometry in favor of a hyperbolic Poincaré ball model, effectively decoupling weak targets from massive structural clutter.

### 🌟 Key Highlights

1. **Dual-prior Probabilistic Screening:** Rapidly anchors high-confidence candidate regions using Local Homogeneity Index (LHI) and multiscale Tri-Layer Local Contrast Measure (TLLCM) combined with a highly efficient H-MDPS algorithm.
2. **Adaptive Hyperbolic Manifold Clustering:** Maps features into a Poincaré ball with negative curvature. Combined with tangent-space anisotropic covariance correction, it effectively isolates weak targets from structured clutter by leveraging the exponential expansion property of hyperbolic space.
3. **Physics-Driven Soft-Decision Verification (Strict-LGD):** Employs an energy spillover tolerance mechanism based on Point Spread Function (PSF) priors to filter out pseudo-targets (e.g., highly bright sensor dead pixels) lacking continuous energy diffusion.

## 🚀 Framework

![Framework](docs/framework.png) *(Note: Please upload the framework image from the paper to a `docs` folder and link it here)*

## ⚙️ Prerequisites

The code has been tested on the following environment:
* **OS:** Windows 10/11 or Linux
* **Software:** MATLAB R2024b (or later)
* **Hardware Requirements:** CPU (Intel Core i5-13400F or equivalent), 64 GB RAM recommended for large-scale dataset evaluations.

## 📂 Datasets

The algorithm is evaluated on multiple public and simulated datasets. You can download the datasets from their respective public repositories:
* [NUAA-SIRST](https://github.com/YimianDai/open-acm)
* [NUDT-SIRST](https://github.com/YeRen123455/Infrared-Small-Target-Detection)
* [NUDT-MIRSDT](https://github.com/TinaLRJ/Multi-frame-infrared-small-target-detection-DTUM)
* [IRSTD-1K](https://github.com/RuiZhang97/ISNet)
* [TSIRMT](https://github.com/lifier/LMAFormer)

Place the downloaded datasets into the `./datasets/` directory.

## 🛠️ Usage

1. Clone this repository:
   ```bash
   git clone [https://github.com/yourusername/PA-AHDPC.git](https://github.com/yourusername/PA-AHDPC.git)
   cd PA-AHDPC
