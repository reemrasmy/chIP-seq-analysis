import pandas as pd
import matplotlib.pyplot as plt
from matplotlib_venn import venn2
import seaborn as sns

RNA_seq_data = "GSE75070_MCF7_shRUNX1_shNS_RNAseq_log2_foldchange.tsv"
chip_seq_peaks = "annotated_peaks.tsv"

rna_df = pd.read_csv(RNA_seq_data, sep="\t")
# print(rna_df.head())
print(rna_df.columns)
# print(rna_df.info)
# Applying the thresholds from the paper
sig_genes = rna_df[(rna_df["padj"] < 0.01) & (rna_df["log2FoldChange"].abs() > 1)].copy()
sig_genes["genename"] = sig_genes["genename"].str.upper()

# add up/down label based on log2FoldChange
sig_genes["direction"] = sig_genes["log2FoldChange"].apply(lambda x: "up" if x > 0 else "down")
print(sig_genes["direction"].value_counts())    # up: 687, down: 466 -> consistent with paper

upreg_counts = len(sig_genes[sig_genes["direction"] == "up"])
downreg_counts = len(sig_genes[sig_genes["direction"] == "down"])

print("Total up and downregulated genes:", upreg_counts, downreg_counts)

chip_df = pd.read_csv(chip_seq_peaks, sep="\t")
chip_genes = chip_df["Gene Name"].dropna().str.upper().unique()
print(chip_genes)

sig_genes["has_peak"] = sig_genes["genename"].isin(chip_genes)
print(sig_genes["has_peak"].value_counts())

runx1_bound = sig_genes[sig_genes["has_peak"] == True].copy()
print(runx1_bound["direction"].value_counts())

runx1_up_counts = len(runx1_bound[runx1_bound["direction"] == "up"])
runx1_down_counts = len(runx1_bound[runx1_bound["direction"] == "down"])

print("Up and Downregulated RUNX1-Bound Genes:", runx1_up_counts, runx1_down_counts)

runx1_data = {"direction" : ["up", "down"], "RUNX1 Bound": [runx1_up_counts, runx1_down_counts], "Not Bound": [upreg_counts - runx1_up_counts, downreg_counts - runx1_down_counts]}

runx1_df = pd.DataFrame(runx1_data)

sns.set_theme(style="whitegrid")

# heights for bars from your counts
up_bound = runx1_up_counts
up_not   = upreg_counts - runx1_up_counts

down_bound = runx1_down_counts
down_not   = downreg_counts - runx1_down_counts

plt.figure(figsize=(6, 4))

# UP bar: draw orange (bound) first, then grey (not bound) on top
plt.bar("up", up_bound, width = 0.3, color="red", label="RUNX1 bound")
plt.bar("up", up_not, width = 0.3, bottom=up_bound, color="darkgray", label="Not bound")

# DOWN bar
plt.bar("down", down_bound, width = 0.3, color="red")
plt.bar("down", down_not, width = 0.3, bottom=down_bound, color="darkgray")

# ─────── Counts inside bars ───────
# Up-regulated
plt.text("up", up_bound/2, str(up_bound), ha="center", va="center", fontsize=10)
plt.text("up", up_bound + up_not/2, str(up_not), ha="center", va="center", fontsize=10)

# Down-regulated
plt.text("down", down_bound/2, str(down_bound), ha="center", va="center", fontsize=10)
plt.text("down", down_bound + down_not/2, str(down_not), ha="center", va="center", fontsize=10)

plt.ylabel("Number of Genes")
plt.xlabel("Direction of regulation\n +/- 5kb of TSS ")
plt.title("DE Genes with / without RUNX1 Promoter Binding")
plt.legend()
plt.tight_layout()
plt.show()

from matplotlib_venn import venn2
import matplotlib.pyplot as plt

# Replace these with your actual numbers:
rep1_unique = 9505
rep2_unique = 8345
overlap = 3753

plt.figure(figsize=(4,4))

venn = venn2(subsets=(rep1_unique, rep2_unique, overlap),
      set_labels=("Rep1", "Rep2"))
venn.get_patch_by_id('10').set_color('red')     # Rep1-only
venn.get_patch_by_id('01').set_color('blue')    # Rep2-only
venn.get_patch_by_id('11').set_color('purple')
plt.title("RUNX1 Peak Reproducibility")
plt.show()

print(chip_df[chip_df["Gene Name"].str.upper() == "MALAT1"])
