#!/usr/bin/env python3

import pandas as pd
import sys
import argparse


def write_snps_list(snps_list, output_file):
    """Write list of SNPs to output file"""
    try:
        with open(output_file, 'w') as f:
            for snp in snps_list:
                f.write(f"{snp}\n")
        print(f"Successfully wrote {len(snps_list)} SNPs to {output_file}")
        
    except Exception as e:
        print(f"Error writing to file: {str(e)}")
        sys.exit(1)


def convert_var(variant):
    """Convert from chr_pos_ref_alt to chr:pos+1:ref:alt format"""
    try:
        chrom, pos, ref, alt = variant.split('_')
        # Add 1 to position for 0-based to 1-based conversion
        new_pos = str(int(pos) - 1)
        return f"{chrom}:{new_pos}:{ref}:{alt}"
    except:
        return None


def process_file(input_file, output_file, bf_threshold=0.1):
    """Process the input file and write filtered variants to output"""

    # Read the data into a pandas DataFrame
    data = pd.read_csv(input_file, sep='\t')
    
    # Filter where BF < threshold
    filtered_data = data[data['BF'] < bf_threshold]
    
    snps = [convert_var(i) for i in filtered_data['snps']]

    write_snps_list(snps, output_file)




def main():
    # Set up argument parser
    parser = argparse.ArgumentParser(description='Filter variants based on BF threshold')
    parser.add_argument('-i', '--input', required=True, help='Input file path')
    parser.add_argument('-o', '--output', required=True, help='Output file path')
    parser.add_argument('-t', '--threshold', type=float, default=0.1,
                        help='BF threshold (default: 0.1)')

    # Parse arguments
    args = parser.parse_args()

    # Process the file
    process_file(args.input, args.output, args.threshold)

if __name__ == "__main__":
    main()
