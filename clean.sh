echo "clean up files `date`"
cd $datapath2

# every 06z save 20 member + ens mean restarts.
#if ($analdatem1 >= 2016010400 && $ensmean_restart == 'true' && $hr == '06') then
#    /bin/rm -rf restarts
#    mkdir -p restarts/ensmean
#    /bin/mv -f ensmean/INPUT restarts/ensmean
#    nanal=1
#    while ($nanal <= 20) 
#       charmem="mem`printf %03i $nanal`"
#       /bin/cp -R ${charmem} restarts
#       /bin/rm -f restarts/*/PET* restarts/*/log*
#       @ nanal = $nanal + 1
#    end
#fi

# move every member files to a temp dir.
/bin/rm -rf fgens fgens2
mkdir fgens
mkdir fgens2
if [ $replay_controlfcst == 'true' ]; then
   charnanal='control2'
else
   charnanal='control'
fi
/bin/rm -f mem*/*nc mem*/*txt mem*/*grb mem*/*dat mem*/co2*
/bin/rm -f ${charnanal}/*nc ${charnanal}/*txt ${charnanal}/*grb ${charnanal}/*dat ${charnanal}/co2*
/bin/mv -f mem* fgens
/bin/mv -f sfg*mem* fgens2
/bin/mv -f bfg*mem* fgens2
/bin/cp -f sfg*ensmean fgens2
if [ $replay_controlfcst == 'true' ]; then
/bin/cp -f sfg*control2 bfg*control2 fgens2
else
/bin/cp -f sfg*control bfg*control fgens2
fi

#mkdir analens
#/bin/mv -f sanl_*mem* analens # save analysis ensemble
#echo "files moved to analens `date`"
/bin/rm -f sanl_*mem* # don't save analysis ensemble
/bin/rm -f fgens2/*fhr00* fgens2/*orig
echo "files moved to fgens, fgens2 `date`"
#if [ -z $NOSAT ]; then
# only save control and spread diag files.
#/bin/rm -rf diag*ensmean.nc4
# only save conventional diag files
#mkdir diagsavdir
#/bin/mv -f diag*conv*control*nc4 diag*conv*spread*nc4 diagsavdir
#/bin/rm -f diag*control*nc4 diag*spread*nc4
#/bin/rm -f diagsavdir/diag*conv_gps*
#/bin/mv -f diagsavdir/diag*nc4 .
#/bin/rm -rf diagsavdir
#fi
# delete these to save space
#/bin/rm -f diag*cris* diag*airs* diag*iasi*

/bin/rm -f hostfile*
/bin/rm -f fort*
/bin/rm -f *log
/bin/rm -f *lores *mem*orig
/bin/rm -f ozinfo convinfo satinfo scaninfo anavinfo
/bin/rm -rf *tmp* nodefile* machinefile*
/bin/rm -rf hybridtmp*
if [ $save_hpss_subset == "false" ] && [ $save_hpss_full == "false" ]; then
  /bin/rm -rf fgens fgens2
  /bin/rm -f diag*cris* diag*airs* diag*iasi*
  /bin/rm -f *fhr03* *fhr09* *chgres
  /bin/rm -rf control ensmean
  #if [ $hr != '00' ]; then
      /bin/rm -rf control2
  #fi
  # save backup of next analysis time once per day
  # so analysis can be restarted
  hr=`echo $analdatep1 | cut -c9-10`
  if [ $hr == '00' ]; then
     tar -cvf ${analdatep1}_restart.tar ${analdatep1}
  fi
fi
echo "unwanted files removed `date`"
wait
