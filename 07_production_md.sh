#!/bin/bash
# ============================================================================
# Module 7: Production MD simulation (50 ns) at three temperatures
# ============================================================================

cd ~/ICA_3RF3

# Create production MD parameter file template
cat > md.mdp << EOF
title = Production MD
integrator = md
dt = 0.002
nsteps = 25000000
nstxout = 0
nstvout = 0
nstenergy = 5000
nstlog = 5000
nstxout-compressed = 5000
compressed-x-grps = System
cutoff-scheme = Verlet
rlist = 1.0
rcoulomb = 1.0
rvdw = 1.0
pbc = xyz
tcoupl = V-rescale
tc-grps = Protein Non-Protein
tau_t = 0.1 0.1
pcoupl = Parrinello-Rahman
pcoupltype = isotropic
tau_p = 2.0
ref_p = 1.0
compressibility = 4.5e-5
continuation = yes
constraints = h-bonds
constraint_algorithm = lincs
lincs_order = 4
lincs_iter = 1
comm-mode = Linear
comm-grps = Protein
EOF

# ============================================================================
# 300K production run
# ============================================================================
mkdir -p md_300
cp npt.gro npt.cpt topol.top md_300/
cd md_300

# Create temperature-specific mdp file
sed 's/ref_t = 300 300/ref_t = 300 300/' ../md.mdp > md_300.mdp

# Generate binary input
gmx grompp -f md_300.mdp -c npt.gro -t npt.cpt -p topol.top -o md_300.tpr -maxwarn 1

# Run production MD with GPU acceleration (16 threads as per server rules)
gmx mdrun -v -deffnm md_300 -ntomp 16 -nb gpu

cd ..

# ============================================================================
# 280K production run
# ============================================================================
mkdir -p md_280
cp npt.gro npt.cpt topol.top md_280/
cd md_280

# Modify temperature to 280K
sed 's/ref_t = 300 300/ref_t = 280 280/' ../md.mdp > md_280.mdp

gmx grompp -f md_280.mdp -c npt.gro -t npt.cpt -p topol.top -o md_280.tpr -maxwarn 1
gmx mdrun -v -deffnm md_280 -ntomp 16 -nb gpu

cd ..

# ============================================================================
# 320K production run
# ============================================================================
mkdir -p md_320
cp npt.gro npt.cpt topol.top md_320/
cd md_320

# Modify temperature to 320K
sed 's/ref_t = 300 300/ref_t = 320 320/' ../md.mdp > md_320.mdp

gmx grompp -f md_320.mdp -c npt.gro -t npt.cpt -p topol.top -o md_320.tpr -maxwarn 1
gmx mdrun -v -deffnm md_320 -ntomp 16 -nb gpu

cd ..