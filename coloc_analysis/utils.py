
def read_ld(ld_file):
    LD = dict()
    
    i = 0
    with open(ld_file, "r") as file:
        # Iterate over each line in the file
        for line in file:
            if i == 0:
                i += 1
                continue
            else:
                tokens = line.strip().split()
                a_id = tokens[2]
                b_id = tokens[5]
                if a_id not in LD:
                    LD[a_id] = set([b_id])
                else:
                    LD[a_id].add(b_id)
    
                if b_id not in LD:
                    LD[b_id] = set([a_id])
                else:
                    LD[b_id].add(a_id)
    return LD


def check_coloc(id, check_set, ld_dict):
    if id in check_set:
        return 999
    else:
        tem_set = ld_dict.get(id, set())
        res = check_set.intersection(tem_set)
        return len(res)


def get_coloc(df, ld_dict):
    res = []
    for index, row in df.iterrows():
        res.append(check_coloc(row.snps, check_set, ld_dict))
    df['coloc'] = res
    return df

















