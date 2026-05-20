# Temperature-dependent Molecular Dynamics Simulation of the IpaA–Vinculin Protein Complex

## 1. Background and Scientific Question

IpaA is a key virulence factor of *Shigella flexneri*. It binds to the host protein vinculin and manipulates the host cytoskeleton to promote bacterial invasion. This protein–protein interaction is a central component of the pathogenic mechanism of *Shigella*.

**Scientific question addressed in this work: How does temperature affect the structural stability, compactness, binding-interface strength, and secondary-structure composition of the IpaA–vinculin complex?**

To answer this question, we performed all-atom molecular dynamics (MD) simulations of the PDB structure **3RF3** at **three temperatures: 280 K, 300 K, and 320 K**. Each simulation was run for **50 ns**, and the behaviour of the complex was compared using four structural analysis metrics.

---

## 2. Software and Force Field

| Item | Description |
|---|---|
| MD engine | GROMACS (GPU acceleration, 16 OpenMP threads) |
| Force field | AMBER99SB-ILDN |
| Water model | TIP3P |
| Initial structure source | RCSB PDB: [3RF3](https://www.rcsb.org/structure/3RF3) |

---

## 3. Workflow Overview

```text
01_setup_pdb.sh           Download PDB → add hydrogen atoms → generate topology
02_box_solvate.sh         Define cubic box (1.0 nm boundary) → solvate with TIP3P water
03_add_ions.sh            Add Na⁺/Cl⁻ ions to neutralize charge → physiological salt concentration (0.15 M)
04_energy_minimization.sh Steepest-descent energy minimization (50,000 steps)
05_nvt_equilibration.sh   NVT equilibration (100 ps, 300 K, position restraints)
06_npt_equilibration.sh   NPT equilibration (100 ps, 300 K, 1 bar)
07_production_md.sh       Production MD (50 ns) × 3 temperatures (280 K / 300 K / 320 K)
08_analysis_rmsd.sh       Backbone RMSD analysis
09_analysis_gyrate.sh     Radius of gyration (Rg) analysis
10_analysis_hbond.sh      Inter-chain hydrogen-bond analysis
11_analysis_dssp.sh       Secondary-structure analysis using DSSP
12_extract_final_structure.sh Extract final-frame protein structure (PDB)
4. Simulation Protocol
Parameter	Setting
Integration time step	2 fs
Production MD length	50 ns (25,000,000 steps)
Non-bonded cutoff radius (Coulomb + vdW)	1.0 nm
Long-range electrostatics	PME (Particle Mesh Ewald)
Constraint algorithm	LINCS, including bonds involving hydrogen
Temperature coupling	V-rescale, with protein and non-protein groups coupled separately
Pressure coupling	Parrinello–Rahman, isotropic, 1 bar
Production MD temperature conditions	280 K, 300 K, 320 K
Trajectory output frequency	One frame every 10 ps
5. Rationale for the Three-temperature Design
Temperature	Scientific rationale
280 K	Slightly below room temperature; represents a low-temperature condition and tests whether the complex becomes more rigid or compact
300 K	Close to room temperature and used as the reference condition
320 K	Above room temperature; represents mild thermal stress and tests whether the complex becomes unstable, dissociates, or loses secondary structure
6. Analysis Metrics and Physical Interpretation
Analysis	Command	Measured object	Scientific interpretation
RMSD	gmx rms	Backbone atoms	Degree of structural deviation from the initial conformation; lower RMSD indicates greater structural stability
Radius of gyration (Rg)	gmx gyrate	All protein Cα atoms	Compactness of the protein complex; increased Rg suggests expansion or partial unfolding
Inter-chain hydrogen bonds	gmx hbond	Chain A (IpaA) ↔ Chain B (vinculin)	Strength of the binding interface; fewer hydrogen bonds suggest weakening of the complex interface
Secondary structure (DSSP)	gmx dssp	Each residue	Temperature-dependent changes in α-helix, β-sheet, turn, and random-coil content

For all metrics, the mean and standard deviation were calculated over the final 10 ns (40–50 ns) equilibrium window to ensure that the analysis reflects the relaxed stage of the simulations.

7. Usage
# Run the scripts sequentially
bash 01_setup_pdb.sh
bash 02_box_solvate.sh
bash 03_add_ions.sh
bash 04_energy_minimization.sh
bash 05_nvt_equilibration.sh
bash 06_npt_equilibration.sh
bash 07_production_md.sh
bash 08_analysis_rmsd.sh
bash 09_analysis_gyrate.sh
bash 10_analysis_hbond.sh
bash 11_analysis_dssp.sh
bash 12_extract_final_structure.sh

Requirement: GROMACS must be installed and configured with GPU support.

8. Output File Structure
~/ICA_3RF3/
├── complex.gro / topol.top          # Topology and initial structure
├── solv_ions.gro                    # Solvated and ionized system
├── em.gro                           # Energy-minimized structure
├── nvt.gro / npt.gro                # Equilibrated structures
├── md_280/   md_300/   md_320/      # Production MD results for the three temperatures
│   ├── md_XXX.xtc                   # Trajectory file
│   ├── md_XXX.tpr / .cpt / .log
│   ├── rmsd_XXX.xvg                 # RMSD time series
│   ├── gyrate_XXX.xvg               # Radius of gyration time series
│   ├── hbond_XXX.xvg                # Inter-chain hydrogen-bond time series
│   ├── ss_XXX.dat                   # Secondary-structure assignment data
│   └── final_XXX_protein.pdb        # Final frame, protein only
9. Expected Conclusions

By comparing the four metrics across the three temperatures, this workflow can address the following questions:

Does high temperature (320 K) significantly increase RMSD?
→ Tests whether the overall complex structure becomes destabilized.
Does high temperature increase Rg?
→ Tests whether the protein complex undergoes thermal expansion or partial unfolding.
Does high temperature reduce the number of inter-chain hydrogen bonds?
→ Tests whether the binding interface weakens under thermal stress.
Does high temperature alter secondary-structure composition?
→ Tests whether specific structural elements, such as α-helices or β-sheets, differ in thermal stability.
