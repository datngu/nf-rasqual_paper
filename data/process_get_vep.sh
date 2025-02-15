for fi in randomized_tie_lead_snps/*txt
do
    fo=$(basename "$fi")
    python get_VEP_input.py --input ${fi} --output randomized_tie_lead_snps/VEP_input_${fo}
done