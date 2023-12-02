#!/bin/bash -l
#PBS -N lqfrac
#PBS -A NRAL0017
#PBS -l select=1:ncpus=1:mem=30GB
#PBS -l walltime=05:00:00
#PBS -q casper
#PBS -j oe
#PBS -k oed

export TMPDIR=/glade/scratch/$USER/temp
mkdir -p $TMPDIR

# unset DASK_ROOT_CONFIG

source /glade/work/ishitas/python_envs/py_casper/bin/activate

python /glade/work/ishitas/CONUS_Retro_Run/rechunk_retro_nwm_v21/lqfrac/lqfrac_to_zarr.py > /glade/derecho/scratch/ishitas/CONUS/forcing/lqfrac_log

exit 0
