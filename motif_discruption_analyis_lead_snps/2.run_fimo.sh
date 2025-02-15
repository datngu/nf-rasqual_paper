#!/bin/bash
#SBATCH --ntasks=1
#SBATCH --nodes=1                
#SBATCH --job-name=neg_fimo   
#SBATCH --mem=16G                
#SBATCH --partition=gpu
#SBATCH --mail-user=nguyen.thanh.dat@nmbu.no
#SBATCH --mail-type=ALL


module load BCFtools/1.10.2-GCC-8.3.0
module load git/2.23.0-GCCcore-9.3.0-nodocs
module load Nextflow/21.03
module load singularity/rpm

## build singularity

# singularity pull docker://memesuite/memesuite:5.5.7
# docker pull memesuite/memesuite:5.5.7


## brain
singularity exec -B $(pwd):/mnt memesuite_latest.sif fimo \
    --thresh 0.01 \
    --max-stored-scores 1000000 \
    --text \
    --no-qvalue \
    --skip-matched-sequence \
    /mnt/JASPAR2020_CORE_vertebrates_non-redundant_pfms_meme.txt /mnt/brain.fa > brain_fimo.tsv


python process_fimo.py --fimo brain_fimo.tsv --out brain_disrupted.csv

## liver

singularity exec -B $(pwd):/mnt memesuite_latest.sif fimo \
    --thresh 0.01 \
    --max-stored-scores 1000000 \
    --text \
    --no-qvalue \
    --skip-matched-sequence \
    /mnt/JASPAR2020_CORE_vertebrates_non-redundant_pfms_meme.txt /mnt/liver.fa > liver_fimo.tsv


python process_fimo.py --fimo liver_fimo.tsv --out liver_disrupted.csv


## gonad

singularity exec -B $(pwd):/mnt memesuite_latest.sif fimo \
    --thresh 0.01 \
    --max-stored-scores 1000000 \
    --text \
    --no-qvalue \
    --skip-matched-sequence \
    /mnt/JASPAR2020_CORE_vertebrates_non-redundant_pfms_meme.txt /mnt/gonad.fa > gonad_fimo.tsv

python process_fimo.py --fimo gonad_fimo.tsv --out gonad_disrupted.csv


## muscle
singularity exec -B $(pwd):/mnt memesuite_latest.sif fimo \
    --thresh 0.01 \
    --max-stored-scores 1000000 \
    --text \
    --no-qvalue \
    --skip-matched-sequence \
    /mnt/JASPAR2020_CORE_vertebrates_non-redundant_pfms_meme.txt /mnt/muscle.fa > muscle_fimo.tsv

python process_fimo.py --fimo muscle_fimo.tsv --out muscle_disrupted.csv







