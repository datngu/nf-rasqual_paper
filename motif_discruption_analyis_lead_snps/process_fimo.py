#!/usr/bin/env python
# coding: utf-8

import csv
import argparse


def get_ratio(x, y):
    if x < 1e-4 or y < 1e-4:
        return x / y if x > y else y / x
    else:
        return 1.


def write_csv(data, filepath):
    with open(filepath, 'w') as file:
        writer = csv.writer(file)
        writer.writerow(['key', 'snp', 'motif', 'ratio', 'disrupted'])  # Write header
        for key, value in data.items():
            s, m = key.split(':')
            d = 0 if value < 10 else 1
            writer.writerow([key, s, m, value, d])


def read_fimo_res(filepath):
    """
    Reads a FIMO results file, processes data line by line, and computes a ratio 
    based on strand and p-value.

    :param filepath: Path to the FIMO results file.
    :return: Dictionary with computed ratios.
    """
    seq_dict = {}
    res_dict = {}
    with open(filepath, 'r') as file:
        next(file)  # Skip the first line (header)
        for line in file:
            tokens = line.strip().split('\t')
            id = tokens[2][:-4] + ':' + tokens[0]
            strand = tokens[5]
            pval = float(tokens[7])
            if strand == '+':
                if id in seq_dict:
                    res_dict[id] = get_ratio(pval, seq_dict.get(id))
                else:
                    seq_dict[id] = pval

    return res_dict


def main():
    parser = argparse.ArgumentParser(description="Process FIMO results and compute ratios.")
    parser.add_argument('--fimo', required=True, help="Path to the FIMO results file.")
    parser.add_argument('--out', required=True, help="Output CSV file path.")
    args = parser.parse_args()

    # Process the FIMO file
    results = read_fimo_res(args.fimo)

    # Write results to CSV
    write_csv(results, args.out)


if __name__ == "__main__":
    main()
