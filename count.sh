tis='Brain'
atac_res=data/${tis}/EXTERNAL_LD_ATAC_eigenMT_results_merged/ALL_eigenMT_results.txt
rna_res=data/${tis}/EXTERNAL_LD_RNA_eigenMT_results_merged/ALL_eigenMT_results.txt


for tis in 'Brain' 'Gonad' 'Liver' 'Muscle'
do 
    tail -n +2 data/${tis}/EXTERNAL_LD_ATAC_eigenMT_results_merged/ALL_eigenMT_results.txt | wc -l
done

for tis in 'Brain' 'Gonad' 'Liver' 'Muscle' 'Gill'
do 
    tail -n +2 data/${tis}/EXTERNAL_LD_RNA_eigenMT_results_merged/ALL_eigenMT_results.txt | wc -l
done
