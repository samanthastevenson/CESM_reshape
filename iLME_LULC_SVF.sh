# Run SVF postprocessing on iLME LULC member #1 using command-line PyReshaper

#!/usr/bin/bash

#module load conda
#conda activate npl_ss2023

# Full list of prefixes for model components: choose a subset that fits your needs
#declare -a comps=('cice.h' 'clm2.h0' 'clm2.h1' 'pop.h.nday1' 'pop.h' 'cam.h0' 'cam.h1')

declare -a comps=('clm2.h0')
case="b.ie12.B1850C5CN.f19_g16.LME.LULC.001"
startyr="1690"
endyr="2005"

# Loop over components/frequencies
for comp in "${comps[@]}"; do
    echo ${comp}

    case ${comp} in
        cam.h1)
            dir='atm'
            subdir='daily'
            ;;
            
        cam.h0)
            dir='atm'
            subdir='monthly'
            ;;
        pop.h)
            dir='ocn'
            subdir='monthly'
            ;;
        cice.h)
            dir='ice'
            subdir='monthly'
            ;;
        clm2.h0)
            dir='lnd'
            subdir='monthly'
            ;;
        clm2.h1)
            dir='lnd'
            subdir='daily'
            ;;
        pop.h.nday1)
            dir='ocn'
            subdir='daily'
            ;;
    esac


    s2smake \
      --netcdf_format="netcdf4" \
      --compression_level=1 \
      --output_prefix="/glade/campaign/univ/ucsb0006/CESM-CAM5-LME/"${dir}"/proc/tseries/"${subdir}"/"${case}"."${comp}"." \
      --output_suffix="."${startyr}01-${endyr}12.nc \
      -m "time" -m "time_bounds" \
      --specfile=${case}"_"${comp}.s2s \
      /glade/scratch/samantha/${case}/archive/${dir}/hist/${case}"."${comp}"."[1-2]*.nc
  
    s2srun --serial --verbosity=2 ${case}"_"${comp}.s2s

done

