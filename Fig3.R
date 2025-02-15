library(dplyr)
require(data.table)
library(ggplot2)

get_vep = function(prefix){
  file = paste0('data/vep_results/', prefix, '.txt')
  data = fread(file)
  data$Type = prefix
  
  return(data)
}

all_types = c('Brain_eQTL', 'Brain_caQTL', 'Gonad_eQTL', 'Gonad_caQTL', 
              'Liver_eQTL', 'Liver_caQTL', 'Muscle_eQTL', 'Muscle_caQTL', 'Gill_eQTL')

# Apply the get_vep function to each prefix in all_types
df_list <- lapply(all_types, get_vep)

# Combine all data frames into one 
combined_df <- rbindlist(df_list, use.names = TRUE, fill = TRUE)

# Identify the top most frequent classes
consequence_counts <- table(combined_df$Consequence)
top_classes <- names(sort(consequence_counts, decreasing = TRUE)[1:6])

# Replace all other classes with 'other' and make Consequence a factor with ordered levels
combined_df$Consequence <- factor(
  ifelse(combined_df$Consequence %in% top_classes, combined_df$Consequence, 'other'),
  levels = c(top_classes, 'other')  # Set the order of levels
)

# Compute frequency and proportion
fq_table <- combined_df %>%
  group_by(Type, Consequence) %>%
  summarise(Frequency = n(), .groups = "drop") %>%
  group_by(Type) %>%
  mutate(Proportion = Frequency / sum(Frequency))

# Remove underscores from Type and Consequence
fq_table$Type <- gsub("_", " ", fq_table$Type)
fq_table$Consequence <- as.character(fq_table$Consequence)
fq_table$Consequence[fq_table$Consequence != "other"] <- 
  gsub("_", " ", fq_table$Consequence[fq_table$Consequence != "other"])
fq_table$Consequence <- factor(fq_table$Consequence, 
                               levels = c(gsub("_", " ", top_classes), "other"))

# Plot side-by-side bar chart
plot = ggplot(fq_table, aes(x = Type, y = Proportion, fill = Consequence)) +
  geom_bar(stat = "identity", position = position_dodge(width = 0.8), color = "black") +
  labs(
    x = "",
    y = "Proportion",
    fill = "Consequence"
  ) +
  theme_minimal() +
  theme(
    axis.text.x = element_text(angle = 45, hjust = 1),
    legend.position = "right"
  )

# Save plot and data
ggsave("proportion_consequences_by_type.pdf", plot, width = 8, height = 6)
write_csv(fq_table, file = 'data/vep_results/proportion_summary.csv')
