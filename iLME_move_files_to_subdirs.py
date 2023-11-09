# Reorganize output from pyReshaper LME SVF script

import os
import shutil

case="b.ie12.B1850C5CN.f19_g16.LME.LULC.001"
basedir="/glade/campaign/univ/ucsb0006/CESM-CAM5-LME/"
comp="lnd"
freq="monthly"
pref="clm2.h0"

# Find appropriate directory
f=os.listdir(basedir+comp+'/proc/tseries/'+freq)
# Get all netCDF files for that case
hfiles=[h for h in f if case in h and ".nc" in h]   

# Loop over files, put them in the right place
for hf in hfiles:
    # Path to pre-existing file
    oldfile=basedir+comp+'/proc/tseries/'+freq+'/'+hf
    print(oldfile)
    
    # Split filename into case name, suffix for date range
    txt=hf.split(pref)    
    
    # Further split to get name of variable for subdirectory
    vtxt=txt[1].split(".")    
    vtxt2=vtxt[1].split(".")
    
    # If subdirectory doesn't exist, make one
    #if ~os.path.isdir(basedir+comp+'/proc/tseries/'+freq+'/'+vtxt2[0]+'/'):
    #    os.mkdir(basedir+comp+'/proc/tseries/'+freq+'/'+vtxt2[0]+'/')
    
    newfile=basedir+comp+'/proc/tseries/'+freq+'/'+vtxt2[0]+'/'+txt[0]+pref+'.'+vtxt[1]
    
    # Make sure subdirectory exists before moving
    if os.path.isdir(basedir+comp+'/proc/tseries/'+freq+'/'+vtxt2[0]+'/'):
        shutil.move(oldfile,newfile)