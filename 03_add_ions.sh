#!/bin/bash
# ============================================================================
# Module 3: Add counter-ions to neutralize system
# ============================================================================

cd ~/ICA_3RF3

# Create minimization parameter file for ions
cat > ions.mdp << EOF
integrator = steep
nsteps = 50
emtol = 1000
emstep = 0.01
EOF

# Generate binary input file for ions
gmx grompp -f ions.mdp -c solv.gro -p topol.top -o ions.tpr

# Add Na+ and Cl- ions to neutralize charge (0.15 M concentration)
# Select SOL group to replace with ions
echo "SOL" | gmx genion -s ions.tpr -o solv_ions.gro -p topol.top -pname NA -nname CL -neutral -conc 0.15