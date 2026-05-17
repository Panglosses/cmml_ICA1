#!/bin/bash
# ============================================================================
# Module 10: Inter-chain hydrogen bond analysis
# ============================================================================

cd ~/ICA_3RF3

# Function to create index file and calculate hbonds
# Note: Chain A (IpaA) atoms 1-4095, Chain B (Vinculin) atoms 4096-4477
analyze_hbond() {
    local temp=$1
    cd md_${temp}
    
    # Create index file to separate chains
    gmx make_ndx -f md_${temp}.tpr -o index.ndx << EOF
keep 0
del 1-14
a 1-4095
name 1 chain_A
a 4096-4477
name 2 chain_B
q
EOF
    
    # Calculate inter-chain hydrogen bonds
    echo -e "1\n2" | gmx hbond -s md_${temp}.tpr -f md_${temp}.xtc -n index.ndx -num hbond_inter_${temp}.xvg -tu ns
    
    # Calculate mean (last 10 ns)
    grep -v "^[@#]" hbond_inter_${temp}.xvg | awk '$1>=40 {sum+=$2; count++} END {print temp "K Hbonds (40-50ns): Mean = " sum/count}' temp=${temp}
    
    cd ..
}

# Run for all three temperatures
analyze_hbond 300
analyze_hbond 280
analyze_hbond 320