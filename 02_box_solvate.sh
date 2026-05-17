#!/bin/bash
# ============================================================================
# Module 2: Define box and add solvent
# ============================================================================

cd ~/ICA_3RF3

# Define cubic box with distance 1.0 nm from protein
gmx editconf -f complex.gro -o box.gro -c -d 1.0 -bt cubic

# Fill the box with water molecules (SPC216 water model)
gmx solvate -cp box.gro -cs spc216.gro -o solv.gro -p topol.top