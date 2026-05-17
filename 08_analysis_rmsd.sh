#!/bin/bash
# ============================================================================
# Module 8: RMSD analysis
# ============================================================================

cd ~/ICA_3RF3

# 300K RMSD
cd md_300
echo "4 4" | gmx rms -s md_300.tpr -f md_300.xtc -o rmsd_300.xvg -tu ns

# Calculate mean and standard deviation (last 10 ns)
grep -v "^[@#]" rmsd_300.xvg | awk '$1>=40 {sum+=$2; sumsq+=$2*$2; count++} END {mean=sum/count; std=sqrt(sumsq/count - mean^2); print "300K RMSD (40-50ns): Mean = " mean " nm, Std = " std " nm"}'
cd ..

# 280K RMSD
cd md_280
echo "4 4" | gmx rms -s md_280.tpr -f md_280.xtc -o rmsd_280.xvg -tu ns
grep -v "^[@#]" rmsd_280.xvg | awk '$1>=40 {sum+=$2; sumsq+=$2*$2; count++} END {mean=sum/count; std=sqrt(sumsq/count - mean^2); print "280K RMSD (40-50ns): Mean = " mean " nm, Std = " std " nm"}'
cd ..

# 320K RMSD
cd md_320
echo "4 4" | gmx rms -s md_320.tpr -f md_320.xtc -o rmsd_320.xvg -tu ns
grep -v "^[@#]" rmsd_320.xvg | awk '$1>=40 {sum+=$2; sumsq+=$2*$2; count++} END {mean=sum/count; std=sqrt(sumsq/count - mean^2); print "320K RMSD (40-50ns): Mean = " mean " nm, Std = " std " nm"}'
cd ..