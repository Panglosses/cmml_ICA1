#!/bin/bash
# ============================================================================
# Module 9: Radius of gyration analysis
# ============================================================================

cd ~/ICA_3RF3

# 300K
cd md_300
echo "1" | gmx gyrate -s md_300.tpr -f md_300.xtc -o gyrate_300.xvg -tu ns
grep -v "^[@#]" gyrate_300.xvg | awk '$1>=40 {sum+=$2; count++} END {print "300K Rg (40-50ns): Mean = " sum/count " nm"}'
cd ..

# 280K
cd md_280
echo "1" | gmx gyrate -s md_280.tpr -f md_280.xtc -o gyrate_280.xvg -tu ns
grep -v "^[@#]" gyrate_280.xvg | awk '$1>=40 {sum+=$2; count++} END {print "280K Rg (40-50ns): Mean = " sum/count " nm"}'
cd ..

# 320K
cd md_320
echo "1" | gmx gyrate -s md_320.tpr -f md_320.xtc -o gyrate_320.xvg -tu ns
grep -v "^[@#]" gyrate_320.xvg | awk '$1>=40 {sum+=$2; count++} END {print "320K Rg (40-50ns): Mean = " sum/count " nm"}'
cd ..