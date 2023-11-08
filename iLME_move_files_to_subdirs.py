# Reorganize output from pyReshaper LME SVF script

import os
import shutil

case="b.ie12.B1850C5CN.f19_g16.LME.LULC.001"
basedir="/glade/campaign/univ/ucsb0006/CESM-CAM5-LME/"
comp="atm"
freq="monthly"
pref="cam.h0"

# Find appropriate directory
f=os.listdir(basedir+comp+'/proc/tseries/'+freq)
# Get all netCDF files for that case
hfiles=[h for h in f if case in h and ".nc" in h]   

# Loop over files, put them in the right place
for hf in hfiles:
    oldfile=basedir+comp+'/proc/tseries/'+freq+'/'+hf
    print(oldfile)
    txt=hf.split(pref)
    
    vtxt=txt[1].split(".")
    
    newfile=basedir+comp+'/proc/tseries/'+freq+'/'+vtxt[0]+'/'+txt[0]+pref+'.'+txt[1]
    print(newfile)
    
    shutil.move(oldfile,newfile)