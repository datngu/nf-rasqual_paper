all_vcf='../../ALL_chrome_phased_filtered_HWE_1e6_biSNPs_MAF_0.01.vcf.gz'
genome='/Users/datn/GENOMES/atlantic_salmon/Salmo_salar.Ssal_v3.1.dna.toplevel.fa'

#bcftools query -f '%CHROM\t%POS0\t%POS\t%ID\n' $all_vcf > all_variant.bed
# awk 'NR > 1 {split($1, pos, "_"); print pos[1]"\t"pos[2]"\t"pos[2]"\t"$1}' $atac_res > ${tis}.bed
# python extract_seq.py $genome ${tis}.bed ${tis}.fa

### run per tissues
tis='brain'

atac_res=../data/randomized_tie_lead_snps/${tis}_atac_randomized_tie_lead_snp.txt
awk 'NR > 1 {split($2, pos, ":"); print pos[2]"\t"pos[3]"\t"pos[4]"\t"$1}' $atac_res > ${tis}.bed
python extract_seq_v1.py $genome ${tis}.bed ${tis}.fa

### run per tissues
tis='gonad'

atac_res=../data/randomized_tie_lead_snps/${tis}_atac_randomized_tie_lead_snp.txt
awk 'NR > 1 {split($2, pos, ":"); print pos[2]"\t"pos[3]"\t"pos[4]"\t"$1}' $atac_res > ${tis}.bed
python extract_seq_v1.py $genome ${tis}.bed ${tis}.fa



### run per tissues
tis='liver'

atac_res=../data/randomized_tie_lead_snps/${tis}_atac_randomized_tie_lead_snp.txt
awk 'NR > 1 {split($2, pos, ":"); print pos[2]"\t"pos[3]"\t"pos[4]"\t"$1}' $atac_res > ${tis}.bed
python extract_seq_v1.py $genome ${tis}.bed ${tis}.fa


### run per tissues
tis='muscle'

atac_res=../data/randomized_tie_lead_snps/${tis}_atac_randomized_tie_lead_snp.txt
awk 'NR > 1 {split($2, pos, ":"); print pos[2]"\t"pos[3]"\t"pos[4]"\t"$1}' $atac_res > ${tis}.bed
python extract_seq_v1.py $genome ${tis}.bed ${tis}.fa