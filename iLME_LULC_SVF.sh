# Run SVF postprocessing on iLME LULC member #1 using command-line PyReshaper

#!/usr/bin/bash

#module load conda
#conda activate npl_ss2023

declare -a comps=('cice.h' 'clm2.h0' 'clm2.h1' 'pop.h.nday1' 'pop.h' 'cam.h0' 'cam.h1')
#  )
case="b.ie12.B1850C5CN.f19_g16.LME.LULC.001"
startyr="1690"
endyr="2005"

# Loop over components/frequencies
for comp in "${comps[@]}"; do

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


# Monthly ocean data
#s2smake \
#  --netcdf_format="netcdf4" \
#  --compression_level=1 \
#  --output_prefix="/glade/scratch/samantha/b.ie12.B1850C5CN.f19_g16.LME.LULC.001/proc/ocn/monthly/b.ie12.B1850C5CN.f19_g16.LME.LULC.001.pop.h." \
#  --output_suffix=".169001-200512.nc" \
#  -m "time" -m "time_bounds" \
#  --specfile=iLME_LULC1_pop_monthly.s2s \
#  /glade/scratch/samantha/b.ie12.B1850C5CN.f19_g16.LME.LULC.001/archive/ocn/hist/b.ie12.B1850C5CN.f19_g16.LME.LULC.001.pop.h.*.nc
  
#s2srun --serial --verbosity=2 iLME_LULC1_pop_monthly.s2s


# Monthly atmosphere data
#s2smake \
#  --netcdf_format="netcdf4" \
#  --compression_level=1 \
#  --output_prefix="/glade/scratch/samantha/b.ie12.B1850C5CN.f19_g16.LME.LULC.001/proc/atm/monthly/b.ie12.B1850C5CN.f19_g16.LME.LULC.001.cam.h0." \
#  --output_suffix=".169001-200512.nc" \
#  -m "time" -m "time_bounds" \
#  --specfile=iLME_LULC1_cam_monthly.s2s \
#  /glade/scratch/samantha/b.ie12.B1850C5CN.f19_g16.LME.LULC.001/archive/atm/hist/b.ie12.B1850C5CN.f19_g16.LME.LULC.001.cam.h0.*.nc
  
#s2srun --serial --verbosity=2 iLME_LULC1_cam_monthly.s2s

