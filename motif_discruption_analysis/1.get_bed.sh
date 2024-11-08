all_vcf='../../ALL_chrome_phased_filtered_HWE_1e6_biSNPs_MAF_0.01.vcf.gz'
genome='/Users/datn/GENOMES/atlantic_salmon/Salmo_salar.Ssal_v3.1.dna.toplevel.fa'

bcftools query -f '%CHROM\t%POS0\t%POS\t%ID\n' $all_vcf > all_variant.bed

### run per tissues
tis='Brain'

atac_res=../data/${tis}/EXTERNAL_LD_ATAC_eigenMT_results_merged/ALL_eigenMT_results.txt

awk 'NR > 1 {split($2, pos, ":"); print pos[2]"\t"pos[3]"\t"pos[4]"\t"$1"\t"$2"\t"$7}' $atac_res > ${tis}.bed

## filtering postive set
awk '$6 < 0.1' ${tis}.bed > ${tis}_significant.bed

bedtools intersect -a all_variant.bed -b ${tis}_significant.bed | awk '!seen[$NF]++' > ${tis}_snp_in_peak.bed

python extract_seq.py $genome ${tis}_snp_in_peak.bed ${tis}.fa

# ## negative set

# awk '$6 > 0.9' ${tis}.bed > ${tis}_negative_significant.bed

# bedtools intersect -a all_variant.bed -b ${tis}_negative_significant.bed | awk '!seen[$NF]++' > ${tis}_negative_snp_in_peak.bed

# python extract_seq.py $genome ${tis}_negative_snp_in_peak.bed ${tis}_negative.fa

### run per tissues
tis='Gonad'

atac_res=../data/${tis}/EXTERNAL_LD_ATAC_eigenMT_results_merged/ALL_eigenMT_results.txt

awk 'NR > 1 {split($2, pos, ":"); print pos[2]"\t"pos[3]"\t"pos[4]"\t"$1"\t"$2"\t"$7}' $atac_res > ${tis}.bed

## filtering postive set
awk '$6 < 0.1' ${tis}.bed > ${tis}_significant.bed

bedtools intersect -a all_variant.bed -b ${tis}_significant.bed | awk '!seen[$NF]++' > ${tis}_snp_in_peak.bed

python extract_seq.py $genome ${tis}_snp_in_peak.bed ${tis}.fa


### run per tissues
tis='Liver'

atac_res=../data/${tis}/EXTERNAL_LD_ATAC_eigenMT_results_merged/ALL_eigenMT_results.txt

awk 'NR > 1 {split($2, pos, ":"); print pos[2]"\t"pos[3]"\t"pos[4]"\t"$1"\t"$2"\t"$7}' $atac_res > ${tis}.bed

## filtering postive set
awk '$6 < 0.1' ${tis}.bed > ${tis}_significant.bed

bedtools intersect -a all_variant.bed -b ${tis}_significant.bed | awk '!seen[$NF]++' > ${tis}_snp_in_peak.bed

python extract_seq.py $genome ${tis}_snp_in_peak.bed ${tis}.fa


### run per tissues
tis='Muscle'

atac_res=../data/${tis}/EXTERNAL_LD_ATAC_eigenMT_results_merged/ALL_eigenMT_results.txt

awk 'NR > 1 {split($2, pos, ":"); print pos[2]"\t"pos[3]"\t"pos[4]"\t"$1"\t"$2"\t"$7}' $atac_res > ${tis}.bed

## filtering postive set
awk '$6 < 0.1' ${tis}.bed > ${tis}_significant.bed

bedtools intersect -a all_variant.bed -b ${tis}_significant.bed | awk '!seen[$NF]++' > ${tis}_snp_in_peak.bed

python extract_seq.py $genome ${tis}_snp_in_peak.bed ${tis}.fa