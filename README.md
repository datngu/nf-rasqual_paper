# nf-rasqual_paper

This repository contains data and analysis scripts for the nf-rasqual manuscript. The project includes code and workflows for colocalization analysis, motif disruption analysis, and figure generation.

## Directory Structure

```
Fig2.png, Fig2.R
Fig3.pdf, Fig3.R
Fig4.ipynb, Fig4.pdf
README.md
coloc_analysis/
    brain_ids.txt, Brain.ipynb, brain.ld, brain.vcf.gz
    get_ld_tissue.sh
    gonad_ids.txt, Gonad.ipynb, gonad.ld, gonad.vcf.gz
    liver_ids.txt, Liver.ipynb, liver.ld, liver.vcf.gz
    muscle_ids.txt, Muscle.ipynb, muscle.ld, muscle.vcf.gz
    run_all.sh
    utils.py
    __pycache__/
data/
    get_VEP_input.py
    process_get_vep.sh
    tissue_discuptions.csv
    output_nf_rasqual/
    randomized_tie_lead_snps/
motif_discruption_analyis_lead_snps/
    1.get_bed.sh
    2.run_fimo.sh
    extract_seq.py
```

## Main Components

### Colocalization Analysis (`coloc_analysis/`)
- Jupyter notebooks for each tissue: [`Brain.ipynb`](coloc_analysis/Brain.ipynb), [`Gonad.ipynb`](coloc_analysis/Gonad.ipynb), [`Liver.ipynb`](coloc_analysis/Liver.ipynb), [`Muscle.ipynb`](coloc_analysis/Muscle.ipynb)
- Utilities: [`utils.py`](coloc_analysis/utils.py)
- Shell scripts for LD calculation: [`get_ld_tissue.sh`](coloc_analysis/get_ld_tissue.sh), [`run_all.sh`](coloc_analysis/run_all.sh)
- Input files: `*_ids.txt`, `*.ld`, `*.vcf.gz`

### Motif Disruption Analysis (`motif_discruption_analyis_lead_snps/`)
- BED file generation: [`1.get_bed.sh`](motif_discruption_analyis_lead_snps/1.get_bed.sh)
- Sequence extraction: [`extract_seq.py`](motif_discruption_analyis_lead_snps/extract_seq.py)
- FIMO motif scan: [`2.run_fimo.sh`](motif_discruption_analyis_lead_snps/2.run_fimo.sh)

### Data Preparation (`data/`)
- VEP input preparation: [`get_VEP_input.py`](data/get_VEP_input.py)
- VEP processing: [`process_get_vep.sh`](data/process_get_vep.sh)
- Randomized lead SNPs: `randomized_tie_lead_snps/`
- Output from nf-rasqual: `output_nf_rasqual/`
- Tissue disruption summary: `tissue_discuptions.csv`

### Figures
- R scripts: [`Fig2.R`](Fig2.R), [`Fig3.R`](Fig3.R)
- Jupyter notebook: [`Fig4.ipynb`](Fig4.ipynb)
- Output figures: `Fig2.png`, `Fig3.pdf`, `Fig4.pdf`

## Installation

### 1. Clone the repository

```sh
git clone https://github.com/datn/nf-rasqual_paper.git
cd nf-rasqual_paper
```

### 2. Install Python dependencies

Python scripts require:
- `pandas`
- `pysam`
- `ipython` (for notebooks)

Install with pip:

```sh
pip install pandas pysam ipython
```

### 3. R dependencies

R scripts use:
- `ggplot2`
- `ggpubr`

Install in R:

```r
install.packages("ggplot2")
install.packages("ggpubr")
```

### 4. Other dependencies

- **bcftools** (for VCF processing)
- **plink** (for LD calculation)
- **singularity** (for running FIMO via container)
- **memesuite** (FIMO motif scanning)

On a Linux system, install with:

```sh
# Example for Ubuntu
sudo apt-get install bcftools plink singularity-container
```

For memesuite, use singularity as shown in [`2.run_fimo.sh`](motif_discruption_analyis_lead_snps/2.run_fimo.sh):

```sh
singularity pull docker://memesuite/memesuite:5.5.7
```

## Usage

### Colocalization Analysis

Run the analysis for each tissue using the Jupyter notebooks in [`coloc_analysis/`](coloc_analysis/):

- Open and run [`Brain.ipynb`](coloc_analysis/Brain.ipynb), [`Gonad.ipynb`](coloc_analysis/Gonad.ipynb), [`Liver.ipynb`](coloc_analysis/Liver.ipynb), [`Muscle.ipynb`](coloc_analysis/Muscle.ipynb)

### Motif Disruption Analysis

1. Generate BED files and extract sequences:
    - Run [`1.get_bed.sh`](motif_discruption_analyis_lead_snps/1.get_bed.sh)

2. Scan for motif disruptions:
    - Run [`2.run_fimo.sh`](motif_discruption_analyis_lead_snps/2.run_fimo.sh)

### Data Preparation

- Prepare VEP input: Run [`get_VEP_input.py`](data/get_VEP_input.py)
- Process VEP output: Run [`process_get_vep.sh`](data/process_get_vep.sh)

### Figures

- Generate figures by running [`Fig2.R`](Fig2.R), [`Fig3.R`](Fig3.R), and [`Fig4.ipynb`](Fig4.ipynb)

## Contact

Any questions, please contact: ndat "at" utexas "dot" edu or report an issue.
