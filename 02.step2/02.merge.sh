#!/bin/bash
#SBATCH --job-name=merge
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=16
#SBATCH --mem=128GB
#SBATCH -t 6:00:00
#SBATCH -o ./log/output.%j.out
#SBATCH -e ./log/output.%j.err

cd $SLURM_SUBMIT_DIR
mkdir -p pgen_files

module load plink/2.00a3.6

plink2 --pmerge-list merge_list.txt --make-pgen --out /scratch/richards/satoshi.yoshiji/40.CLSA_TG_to_HDL/02.regenie/02.filter_impute/merged/merged
