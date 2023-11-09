# Run SVF postprocessing on iLME LULC member #1 using command-line PyReshaper

# !/usr/bin/bash

# Full set of file prefixes for all model components: you may not want to run all of them at once depending on runtimes
# cice.h: monthly sea ice output
# clm2.h0: monthly land output
# clm2.h1: daily land output
# pop.h.nday1: daily ocean output
# pop.h: monthly ocean output
# cam.h0: monthly atmosphere output
# cam.h1: daily atmosphere output
# declare -a comps=('cice.h' 'clm2.h0' 'clm2.h1' 'pop.h.nday1' 'pop.h' 'cam.h0' 'cam.h1')

declare -a comps=('cam.h1')  # Daily atmosphere data only

# Specify name of case, starting and ending years (these will be used in the final post-processed filename)
case="b.ie12.B1850C5CN.f19_g16.LME.LULC.001"
startyr="1690"
endyr="2005"

# Loop over components/frequencies
for comp in "${comps[@]}"; do
    echo ${comp}

    # Extract appropriate subdirectories to use for given model component
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
    
    #echo /glade/scratch/samantha/${case}/archive/${dir}/hist/${case}"."${comp}"."[^0-9].*.nc
    #echo ${case}"_"${comp}.s2s

    # Call and run PyReshaper
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

