#!/bin/bash
#SBATCH --job-name=step1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=16
#SBATCH --mem=96GB
#SBATCH -t 24:00:00
#SBATCH -o ./log/output.%j.out
#SBATCH -e ./log/output.%j.err

cd $SLURM_SUBMIT_DIR

# conda
source ~/anaconda3/etc/profile.d/conda.sh
conda activate regenie

module load plink/2.00a3.6

# XXX should be EUR/AFR/EAS/SAS
# YYY should be female/male/

mkdir -p $SLURM_SUBMIT_DIR/filtered_XXX_YYY
mkdir -p $SLURM_SUBMIT_DIR/pruned_XXX_YYY

echo "variant filtering"
# create high-quality variants
plink2 --bfile /project/richards/restricted/CLSA/v3/clsa_gen_v3 \
                   --keep /scratch/richards/satoshi.yoshiji/40.CLSA_TG_to_HDL/01.phenotype/output/XXX_YYY_FIDIID_noheader.tsv \
                   --autosome --maf 0.01 --geno 0.01 --mac 10 --hwe 1e-15 --make-pgen \
                   --out $SLURM_SUBMIT_DIR/filtered_XXX_YYY/filtered

echo "variant pruning"
#plink2 --pgen $SLURM_SUBMIT_DIR/filtered_XXX_YYY/filtered --indep-pairwise 1000ct 0.5 \

plink2  \
	   --pfile /scratch/richards/satoshi.yoshiji/40.CLSA_TG_to_HDL/02.regenie/01.step1/XXX_YYY/filtered_XXX_YYY/filtered \
	   --indep-pairwise 1000ct 0.5 \
	   --out $SLURM_SUBMIT_DIR/pruned_XXX_YYY/pruned

echo "regenie step 1"
regenie \
  --step 1 \
  --pgen $SLURM_SUBMIT_DIR/filtered_XXX_YYY/filtered \
  --extract $SLURM_SUBMIT_DIR/pruned_XXX_YYY/pruned.prune.in \
  --covarFile /scratch/richards/satoshi.yoshiji/40.CLSA_TG_to_HDL/01.phenotype/output/XXX_YYY_covar.tsv \
  --phenoFile /scratch/richards/satoshi.yoshiji/40.CLSA_TG_to_HDL/01.phenotype/output/XXX_YYY_pheno.tsv \
  --bsize 1000 \
  --phenoCol rnt_tg_to_hdl \
  --threads 16 \
  --out fit_bin_out

