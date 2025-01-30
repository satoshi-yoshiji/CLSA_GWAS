#!/bin/bash
#SBATCH --job-name=filter_impute
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=16
#SBATCH --mem=96GB
#SBATCH -t 24:00:00
#SBATCH -o ./log/output.%j.out
#SBATCH -e ./log/output.%j.err
#SBATCH --array=1-22

cd $SLURM_SUBMIT_DIR
mkdir -p pgen_files

module load plink/2.00a3.6

plink2 \
--bgen /project/richards/restricted/CLSA/v3/clsa_imp_${SLURM_ARRAY_TASK_ID}_v3.bgen ref-first \
--sample /project/richards/restricted/CLSA/v3/clsa_imp_v3.sample \
--make-pgen erase-phase \
--out pgen_files/clsa_imp_${SLURM_ARRAY_TASK_ID}_v3_filtered

