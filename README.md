# IpaA-Vinculin 蛋白复合物的温度依赖性分子动力学模拟


## 1. 研究背景与科学问题

IpaA 是 *Shigella flexneri* 的关键毒力因子，它通过与宿主细胞内的 vinculin 蛋白结合，操纵宿主细胞骨架以促进细菌入侵。该蛋白-蛋白质相互作用是志贺氏菌致病机制的核心环节。

**本工作探究的科学问题：温度如何影响 IpaA-vinculin 复合物的结构稳定性、紧凑程度、结合界面强度以及二级结构组成？**

为此，我们在 **三个温度 (280 K、300 K、320 K)** 下对 PDB 结构 **3RF3** 分别进行了 **50 ns** 的全原子分子动力学 (MD) 模拟，并通过四项结构分析指标对比了不同温度下的复合物行为。

---

## 2. 软件与力场

| 项目 | 说明 |
|---|---|
| MD 引擎 | GROMACS (GPU 加速，16 OpenMP 线程) |
| 力场 | AMBER99SB-ILDN |
| 水模型 | TIP3P |
| 初始结构来源 | RCSB PDB: [3RF3](https://www.rcsb.org/structure/3RF3) |

---

## 3. 工作流程总览


```
01_setup_pdb.sh          下载 PDB → 添加氢原子 → 生成拓扑
02_box_solvate.sh        定义立方体盒子 (1.0 nm 边界) → 填充 TIP3P 水
03_add_ions.sh           添加 Na⁺/Cl⁻ 中和电荷 → 生理离子浓度 (0.15 M)
04_energy_minimization.sh 最陡下降法能量最小化 (50000 步)
05_nvt_equilibration.sh   NVT 系综平衡 (100 ps, 300 K, 位置约束)
06_npt_equilibration.sh   NPT 系综平衡 (100 ps, 300 K, 1 bar)
07_production_md.sh       成品 MD (50 ns) × 3 个温度 (280 K / 300 K / 320 K)
08_analysis_rmsd.sh       主链 RMSD 分析
09_analysis_gyrate.sh     回旋半径 (Rg) 分析
10_analysis_hbond.sh      链间氢键分析
11_analysis_dssp.sh       二级结构 (DSSP) 分析
12_extract_final_structure.sh 提取最终帧蛋白结构 (PDB)
```

---

## 4. 模拟协议细节

| 参数 | 设定值 |
|---|---|
| 积分步长 | 2 fs |
| 成品 MD 时长 | 50 ns (25,000,000 步) |
| 非键截断半径 (Coulomb + vdW) | 1.0 nm |
| 长程静电 | PME (Particle Mesh Ewald) |
| 约束算法 | LINCS (含氢键) |
| 温度耦合 | V-rescale (310 K, 蛋白与非蛋白分别耦合) |
| 压力耦合 | Parrinello-Rahman (1 bar, 各向同性) |
| 成品 MD 温度条件 | **280 K、300 K、320 K** |
| 轨迹输出频率 | 每 10 ps 一帧 |

---

## 5. 三温度设计理由

| 温度 | 科学意义 |
|---|---|
| **280 K** | 略低于室温，代表低温环境，探究复合物是否变得更刚性、更紧凑 |
| **300 K** | 接近生理温度 (27°C)，作为对照基准 |
| **320 K** | 高于室温，模拟轻度热胁迫，探究复合物是否失稳、解离或二级结构丢失 |

---

## 6. 分析指标与物理意义

| 分析 | 命令 | 测量对象 | 科学解释 |
|---|---|---|---|
| **RMSD** | `gmx rms` | 主链原子 (Backbone) | 结构偏离初始构象的程度；低 RMSD = 结构稳定 |
| **回旋半径 (Rg)** | `gmx gyrate` | 全蛋白 Cα | 蛋白紧凑程度；Rg 增大 = 结构膨胀/部分去折叠 |
| **链间氢键** | `gmx hbond` | Chain A (IpaA) ↔ Chain B (Vinculin) | 结合界面强度；氢键数目减少 = 复合物趋于解离 |
| **二级结构 (DSSP)** | `gmx dssp` | 每个残基 | 温度对 α-螺旋 / β-折叠 / 转角 / 无规卷曲比例的影响 |

> 所有指标均在最后 **10 ns (40–50 ns)** 的平衡段上取均值与标准差，确保数据来自体系已充分弛豫的阶段。

---

## 7. 使用方式

```bash
# 按顺序依次运行
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
```

> 要求：已安装 GROMACS 并配置 GPU 支持。

---

## 8. 输出文件结构

```
~/ICA_3RF3/
├── complex.gro / topol.top          # 拓扑与初始结构
├── solv_ions.gro                    # 溶剂化 + 离子化后的体系
├── em.gro                           # 能量最小化后的结构
├── nvt.gro / npt.gro                # 平衡后的结构
├── md_280/   md_300/   md_320/      # 三个温度的成品 MD 结果
│   ├── md_XXX.xtc                   # 轨迹文件
│   ├── md_XXX.tpr / .cpt / .log
│   ├── rmsd_XXX.xvg                 # RMSD 时间序列
│   ├── gyrate_XXX.xvg               # Rg 时间序列
│   ├── hbond_XXX.xvg                # 链间氢键时间序列
│   ├── ss_XXX.dat                   # 二级结构分配数据
│   └── final_XXX_protein.pdb        # 最终帧 (仅蛋白)
```

---

## 9. 预期结论

通过对比三个温度下的四项指标，可回答以下问题：

1. **高温 (320 K) 是否显著增大 RMSD？** → 判断复合物整体结构是否失稳
2. **高温是否导致 Rg 增大？** → 判断蛋白是否发生热膨胀/部分去折叠
3. **高温是否减少链间氢键数目？** → 判断结合界面是否在热胁迫下弱化
4. **高温是否改变二级结构比例？** → 判断特定结构元件 (α-螺旋/β-折叠) 的热稳定性差异

