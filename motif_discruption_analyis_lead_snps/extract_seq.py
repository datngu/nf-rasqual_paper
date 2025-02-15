#!/usr/bin/env python
# coding: utf-8

import pysam
import pandas as pd
import sys

def extract_sequences(genome, bed_file, out_fa_name, half_len = 15):
    # Open the genome fasta file
    fasta = pysam.FastaFile(genome)
    
    # Output FASTA file name
    #out_fa_name = f'{tis.lower()}.fa'

    # Read the BED file
    bed = pd.read_csv(bed_file, sep='\t', header=None)
    bed.columns = ['chr', 'start', 'end', 'snp']

    # Open the output FASTA file for writing
    with open(out_fa_name, "w") as out_fa:
        for i in range(len(bed)):
            row = bed.iloc[i]
            alt_nuc = row.snp.split('_')[-1]
            # SNP coords are 1-based. 
            seq = fasta.fetch(str(row.chr), row.start-1-half_len, row.start+half_len)
            tem = list(seq)
            tem[half_len] = alt_nuc

        
            # Ensure the reference sequence matches the expected nucleotide
            assert seq[half_len].upper() == row.snp.split('_')[-2], f"{row.snp}: Expected {row.snp.split('_')[-2]} found {seq[half_len].upper()} sequence: {seq}"
            
            if seq[half_len] == row.snp.split('_')[-2]:
                # Create the alternate sequence
                alt_seq = ''.join(tem)

                # Write sequences to the output FASTA file
                out_fa.write(f">{row.snp}_ref\n")
                out_fa.write(f"{seq}\n")
                out_fa.write(f">{row.snp}_alt\n")
                out_fa.write(f"{alt_seq}\n")
            else:
                next

if __name__ == "__main__":
    if len(sys.argv) != 4:
        print("Usage: python extract_seq.py <genome_file> <bed_file> <out_fa_name>")
        sys.exit(1)

    genome = sys.argv[1]
    bed_file = sys.argv[2]
    out_fa_name = sys.argv[3]

    extract_sequences(genome, bed_file, out_fa_name)
