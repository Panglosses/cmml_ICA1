#!/bin/bash
# ============================================================================
# Module 4: Energy minimization (EM)
# ============================================================================

cd ~/ICA_3RF3

# Create EM parameter file
cat > em.mdp << EOF
integrator = steep
nsteps = 50000
emtol = 1000
emstep = 0.01
nstlist = 1
cutoff-scheme = Verlet
rlist = 1.0
rcoulomb = 1.0
rvdw = 1.0
pbc = xyz
EOF

# Generate binary input for EM
gmx grompp -f em.mdp -c solv_ions.gro -p topol.top -o em.tpr

# Run energy minimization
gmx mdrun -v -deffnm em