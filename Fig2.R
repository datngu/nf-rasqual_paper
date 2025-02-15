#setwd('/Volumes/T7_Shield/A_projects/caQTL/result_eigenMT/data')

setwd('/Users/datn/research/caQTL_paper/data/output_nf_rasqual')


require(data.table)
require(ggplot2)
library(ggpubr)
theme_set(theme_classic(base_size = 18))

cutoff = 0.1
get_qq_data <- function( tissue_list, type = "RNA")
{
    res = list()
    for(tis in tissue_list){
        obs_fn = paste0(tis, "/EXTERNAL_LD_", type, "_GET_lead_SNP/obs_rasqual_normial_pval_lead_snp.txt")
        obs = as.data.frame(fread(obs_fn))
        
        nul_fn = paste0(tis, "/EXTERNAL_LD_", type, "_GET_lead_SNP_permute/nul_rasqual_normial_pval_lead_snp.txt")
        nul = as.data.frame(fread(nul_fn))
        
        obs_lead_snp_pval = -log10(sort(as.numeric(obs$pvalue)))
        nul_lead_snp_pval = -log10(sort(as.numeric(nul$pvalue)))
        df = data.frame(obs_lead_snp_pval = obs_lead_snp_pval, nul_lead_snp_pval = nul_lead_snp_pval)
        df$tissue = tis
        res[[tis]] = df
    }
    return(do.call("rbind", res))
}



plot_qq <- function(tissue_list, type) {
    # Assuming `get_qq_data` is a function that returns the data based on the tissue list and type
    rna_qq <- get_qq_data(tissue_list, type)
    
    g = ggplot(rna_qq, aes(x = nul_lead_snp_pval, y = obs_lead_snp_pval, color = tissue)) +
        geom_point() + 
        geom_abline(intercept = 0, slope = 1) + 
        xlab(expression("-log"[10]*"(p) permuted data")) + 
        ylab(expression("-log"[10]*"(p) observed data")) + 
        labs(color = "Tissue") +  # Change legend title to "Tissue"
        theme(legend.position = c(0.05, 0.95), legend.justification = c(0, 1))
    
    return(g)
}

get_statistics_data <- function( tissue_list_RNA, tissue_list_ATAC, cutoff = 0.1)
{
    
    type = "RNA"
    res_rna = list()
    
    for(tis in tissue_list_RNA){
        #obs_fn = paste0("res_collected/", tis, "/obs_", type, "_rasqual_eigenMT_pval.txt")
        obs_fn = paste0( tis, "/EXTERNAL_LD_", type, "_eigenMT_results_merged/ALL_eigenMT_results.txt")
        obs = as.data.frame(fread(obs_fn))
        
        
        nul_fn = paste0( tis, "/EXTERNAL_LD_", type, "_eigenMT_results_merged_permute/ALL_eigenMT_results.txt")
        nul = as.data.frame(fread(nul_fn))
        
        n = nrow(obs)
        n_obs = nrow(obs[obs$BF <= cutoff,])
        n_nul = nrow(nul[nul$BF <= cutoff,])
        
        res_rna[[tis]] = c(n, n_obs, n_nul)
    }
    rna =  as.data.frame(do.call("rbind", res_rna))
    names(rna) = c("n", "n_obs", "n_nul")
    rna$type = "RNA"
    rna$tissue = rownames(rna)
    
    type = "ATAC"
    res_atac = list()
    
    for(tis in tissue_list_ATAC){
        obs_fn = paste0( tis, "/EXTERNAL_LD_", type, "_eigenMT_results_merged/ALL_eigenMT_results.txt")
        obs = as.data.frame(fread(obs_fn))
        
        
        nul_fn = paste0( tis, "/EXTERNAL_LD_", type, "_eigenMT_results_merged_permute/ALL_eigenMT_results.txt")
        nul = as.data.frame(fread(nul_fn))
        
        n = nrow(obs)
        n_obs = nrow(obs[obs$BF <= cutoff,])
        n_nul = nrow(nul[nul$BF <= cutoff,])
        
        res_atac[[tis]] = c(n, n_obs, n_nul)
    }
    atac =  as.data.frame(do.call("rbind", res_atac))
    atac =  as.data.frame(do.call("rbind", res_atac))
    names(atac) = c("n", "n_obs", "n_nul")
    atac$type = "ATAC"
    atac$tissue = rownames(atac)
    
    df = rbind(rna, atac) 
    row.names(df) = NULL
    names(df) = c("Tests", "Significant_BF_0.1", "Expected_FP", "Type", "Tissue")
    df$FDR = df$Expected_FP/df$Significant_BF_0.1
    df = df[,c(4,5,1,2,3,6)]
    return(df)
}


plot_qtl_statistics <- function(df, type = "RNA") {
    # Filter the data based on the given type
    df1 = df2 = df[df$Type == type, ]
    
    # Modify df2 and add the 'Data' column to both df1 and df2
    df2$Significant_BF_0.1 = df2$Expected_FP
    
    df1$Data = "Observation"
    df2$Data = "Permutation"
    
    # Combine the dataframes
    df3 = rbind(df1, df2)
    
    # Create the ggplot object
    p <- ggplot(data = df3, aes(x = Tissue, y = Significant_BF_0.1, fill = Data)) +
        geom_bar(stat = "identity", position = position_dodge()) +
        geom_text(aes(label = Significant_BF_0.1), vjust = -0.25, color = "blue",
                  position = position_dodge(0.9), size = 3.5) +
        scale_fill_brewer(palette = "Paired") +
        ylab("# significant features") +  # Change y-axis label
        theme(legend.position = c(0.95, 0.95), legend.justification = c(1, 1))
    
    return(p)
}



### ploting 

tissue_list_RNA = c("Brain", "Gonad", "Gill", "Liver", "Muscle")
tissue_list_ATAC = c("Brain", "Gonad", "Liver", "Muscle")



rna_qq = plot_qq(tissue_list_RNA, "RNA")

atac_qq = plot_qq(tissue_list_ATAC, "ATAC")


df = get_statistics_data(tissue_list_RNA, tissue_list_ATAC, cutoff = 0.1)

stat_rna =plot_qtl_statistics(df, "RNA")

stat_atac = plot_qtl_statistics(df, "ATAC")



combined_plot <- ggarrange(
    rna_qq, atac_qq, stat_rna, stat_atac,
    labels = c("A", "B", "C", "D"),   # Labels for each plot
    ncol = 2, nrow = 2                # 2 columns, 2 rows
)




png("../../Fig2.png", width = 12, height = 12, units = "in", res = 900)
combined_plot
dev.off()



#ggsave("Fig2.pdf", combined_plot, width = 12, height = 12)
# Open a PDF device
#pdf("Fig2.pdf", width = 12, height = 12)
#combined_plot
#dev.off()


