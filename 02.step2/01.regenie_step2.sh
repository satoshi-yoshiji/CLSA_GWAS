#!/bin/bash
#SBATCH --job-name=step2
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=16
#SBATCH --mem=128GB
#SBATCH -t 10:00:00
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
mkdir -p $SLURM_SUBMIT_DIR/output_XXX_YYY

echo "variant filtering"
# create high-quality variants
plink2 --pfile /scratch/richards/satoshi.yoshiji/40.CLSA_TG_to_HDL/02.regenie/02.filter_impute/merged/merged \
                   --keep /scratch/richards/satoshi.yoshiji/40.CLSA_TG_to_HDL/01.phenotype/output/XXX_YYY_FIDIID_noheader.tsv \
				   --autosome --geno 0.1 --mind 0.1 --mac 10 --hwe 1e-15 keep-fewhet --make-pgen \
                   --out $SLURM_SUBMIT_DIR/filtered_XXX_YYY/filtered


echo "regenie step 2"
regenie \
  --step 2 \
  --pgen $SLURM_SUBMIT_DIR/filtered_XXX_YYY/filtered \
  --covarFile /scratch/richards/satoshi.yoshiji/40.CLSA_TG_to_HDL/01.phenotype/output/XXX_YYY_covar.tsv \
  --phenoFile /scratch/richards/satoshi.yoshiji/40.CLSA_TG_to_HDL/01.phenotype/output/XXX_YYY_pheno.tsv \
  --pred /scratch/richards/satoshi.yoshiji/40.CLSA_TG_to_HDL/02.regenie/01.step1/XXX_YYY/fit_bin_out_pred.list \
  --bsize 1000 \
  --phenoCol rnt_tg_to_hdl \
  --threads 16 \
  --out $SLURM_SUBMIT_DIR/output_XXX_YYY/TG_to_HDL

