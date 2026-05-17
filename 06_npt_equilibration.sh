#!/bin/bash
# ============================================================================
# Module 6: NPT equilibration (constant pressure)
# ============================================================================

cd ~/ICA_3RF3

# Create NPT parameter file
cat > npt.mdp << EOF
title = NPT equilibration
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
pcoupl = Parrinello-Rahman
pcoupltype = isotropic
tau_p = 2.0
ref_p = 1.0
compressibility = 4.5e-5
continuation = no
constraints = h-bonds
constraint_algorithm = lincs
lincs_order = 4
lincs_iter = 1
comm-mode = Linear
comm-grps = Protein
EOF

# Generate binary input for NPT
# -r nvt.gro provides reference coordinates for position restraints
gmx grompp -f npt.mdp -c nvt.gro -r nvt.gro -p topol.top -o npt.tpr -maxwarn 1

# Run NPT equilibration
gmx mdrun -v -deffnm npt