#!/bin/bash

# Ensure the tissue argument is provided
if [ -z "$1" ]; then
    echo "Usage: $0 <tissue>"
    exit 1
fi

# Set the tissue variable
tis=$1

# Define file paths based on the tissue
# atac_res=../data/${tis}/EXTERNAL_LD_ATAC_eigenMT_results_merged/ALL_eigenMT_results.txt
# rna_res=../data/${tis}/EXTERNAL_LD_RNA_eigenMT_results_merged/ALL_eigenMT_results.txt

atac_res=../data/randomized_tie_lead_snps/${tis}_atac_randomized_tie_lead_snp.txt
rna_res=../data/randomized_tie_lead_snps/${tis}_rna_randomized_tie_lead_snp.txt

all_vcf='../../ALL_chrome_phased_filtered_HWE_1e6_biSNPs_MAF_0.01.vcf.gz'

# Extract unique SNP IDs from ATAC and RNA results and store them in ids.txt
cut -f1 $atac_res | tail -n +2 | uniq > tem.txt
cut -f1 $rna_res | tail -n +2 | uniq >> tem.txt
cat tem.txt | uniq > ids.txt
rm tem.txt

# Filter the VCF file based on the SNP IDs
bcftools view -i 'ID=@ids.txt' $all_vcf | bgzip > filtered.vcf.gz

# Create a temporary directory for PLINK files
tem_dir=tem_dir_${tis}
mkdir -p $tem_dir

# Convert the VCF to PLINK binary format
plink --vcf filtered.vcf.gz --make-bed --const-fid --chr-set 29 no-xy no-mt --out $tem_dir/tem_

# Compute pairwise LD (r2) using PLINK
plink --bfile $tem_dir/tem_ \
    --chr-set 29 no-xy no-mt \
    --r2 --ld-window-kb 5000 \
    --ld-window 99999 \
    --ld-window-r2 0.7 \
    --out out_fn

# Move the results to the appropriate filenames
mv filtered.vcf.gz ${tis}.vcf.gz
mv out_fn.ld ${tis}.ld
mv ids.txt ${tis}_ids.txt

# Clean up temporary files and directories
rm -rf $tem_dir
rm out_fn*

echo "LD calculation completed for tissue: $tis"
