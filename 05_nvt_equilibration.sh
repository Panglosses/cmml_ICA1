#!/bin/bash
# ============================================================================
# Module 5: NVT equilibration (constant temperature)
# ============================================================================

cd ~/ICA_3RF3

# Create NVT parameter file
cat > nvt.mdp << EOF
title = NVT equilibration
define = -DPOSRES
integrator = md
dt = 0.002
nsteps = 50000
nstxout = 5000
nstvout = 5000
nstenergy = 5000
nstlog = 5000
nstcalcenergy = 100
nstlist = 10
cutoff-scheme = Verlet
rlist = 1.0
rcoulomb = 1.0
rvdw = 1.0
pbc = xyz
tcoupl = V-rescale
tc-grps = Protein Non-Protein
tau_t = 0.1 0.1
ref_t = 300 300
continuation = no
constraints = h-bonds
constraint_algorithm = lincs
lincs_order = 4
lincs_iter = 1
comm-mode = Linear
comm-grps = Protein
EOF

# Generate binary input for NVT
# -r em.gro provides reference coordinates for position restraints
gmx grompp -f nvt.mdp -c em.gro -r em.gro -p topol.top -o nvt.tpr -maxwarn 1

# Run NVT equilibration
gmx mdrun -v -deffnm nvt