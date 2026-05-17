#!/bin/bash
# ============================================================================
# Module 11: Secondary structure analysis (DSSP)
# ============================================================================

cd ~/ICA_3RF3

# Function to analyze secondary structure
analyze_dssp() {
    local temp=$1
    cd md_${temp}
    
    # Run DSSP
    gmx dssp -s md_${temp}.tpr -f md_${temp}.xtc -o ss_${temp}.dat -tu ns
    
    # Extract secondary structure percentages (last 1000 frames)
    tail -1000 ss_${temp}.dat | awk '
    {
        h = gsub(/H/, "H");
        e = gsub(/E/, "E");
        t = gsub(/T/, "T") + gsub(/S/, "S");
        len = length($0);
        total_h += h; total_e += e; total_t += t; total_len += len;
    }
    END {
        printf "%sK: Helix=%.1f%% Sheet=%.1f%% Turn=%.1f%% Coil=%.1f%%\n", 
               temp, total_h*100/total_len, total_e*100/total_len, 
               total_t*100/total_len, (total_len-total_h-total_e-total_t)*100/total_len;
    }' temp=${temp}
    
    cd ..
}

analyze_dssp 300
analyze_dssp 280
analyze_dssp 320