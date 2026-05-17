#!/bin/bash
# ============================================================================
# Module 12: Extract final structure (last frame) and remove water
# ============================================================================

cd ~/ICA_3RF3

for temp in 300 280 320; do
    cd md_${temp}
    
    # Extract last frame (50 ns)
    echo "0" | gmx trjconv -s md_${temp}.tpr -f md_${temp}.xtc -o final_${temp}.pdb -dump 50000
    
    # Remove water and ions (keep only protein atoms)
    grep "^ATOM" final_${temp}.pdb > final_${temp}_protein.pdb
    
    cd ..
done