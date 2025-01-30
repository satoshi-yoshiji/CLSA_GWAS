#!/bin/bash
#SBATCH --job-name=prune
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=16
#SBATCH --mem=96GB
#SBATCH -t 24:00:00
#SBATCH -o ./log/output.%j.out
#SBATCH -e ./log/output.%j.err

cd $SLURM_SUBMIT_DIR

module load plink/2.00a3.6

plink2 --bfile /project/richards/restricted/CLSA/v3/clsa_gen_v3 --chr 1-22 \
--geno 0.1 \
--mind 0.1 \
--mac 100 \
--indep-pairwise 1000ct 0.5 \
--hwe 1e-15 \
--make-bed \
--out clsa_gen_v3_pruned
