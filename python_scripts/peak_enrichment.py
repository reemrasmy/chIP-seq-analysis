annotated_peaks = open("annotated_peaks.tsv",'r').readlines()

header = annotated_peaks[0].strip().split('\t')
gene_name = header.index('Gene Name')
print(gene_name)
genes = []

for line in annotated_peaks[1:]:
    line = line.strip().split('\t')
    genes.append(line[gene_name])


with open("enriched_genes.txt", 'w') as enriched_genes:

    for gene in genes:
        enriched_genes.write(f"{gene}\n")






