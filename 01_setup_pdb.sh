#!/bin/bash
# ============================================================================
# Module 1: Setup and PDB preparation
# ============================================================================

# Create working directory
mkdir -p ~/ICA_3RF3
cd ~/ICA_3RF3

# Get original PDB file (3RF3.pdb) 
wget https://files.rcsb.org/download/3RF3.pdb
# The structure uses chain B (IpaA) and chain D (vinculin)


# Run pdb2gmx to generate topology and structure files
# Force field: AMBER99SB-ILDN
# Water model: TIP3P
# -ignh ignores hydrogens in input file, letting GROMACS add them
gmx pdb2gmx -f 3RF3.pdb -o complex.gro -p topol.top -ff amber99sb-ildn -water tip3p -ignh