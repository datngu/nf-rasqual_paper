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
    /mnt/JASPAR2020_CORE_vertebrates_non-redundant_pfms_meme.txt /mnt/Brain.fa > brain_fimo.tsv




## liver

singularity exec -B $(pwd):/mnt memesuite_latest.sif fimo \
    --thresh 0.01 \
    --max-stored-scores 1000000 \
    --text \
    --no-qvalue \
    --skip-matched-sequence \
    /mnt/JASPAR2020_CORE_vertebrates_non-redundant_pfms_meme.txt /mnt/Liver.fa > liver_fimo.tsv

## gonad

singularity exec -B $(pwd):/mnt memesuite_latest.sif fimo \
    --thresh 0.01 \
    --max-stored-scores 1000000 \
    --text \
    --no-qvalue \
    --skip-matched-sequence \
    /mnt/JASPAR2020_CORE_vertebrates_non-redundant_pfms_meme.txt /mnt/Gonad.fa > gonad_fimo.tsv


## muscle
singularity exec -B $(pwd):/mnt memesuite_latest.sif fimo \
    --thresh 0.01 \
    --max-stored-scores 1000000 \
    --text \
    --no-qvalue \
    --skip-matched-sequence \
    /mnt/JASPAR2020_CORE_vertebrates_non-redundant_pfms_meme.txt /mnt/Muscle.fa > muscle_fimo.tsv