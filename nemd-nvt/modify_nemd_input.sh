#!/usr/bin/env bash

# use as modify_nemd_input.sh nemd.pol.in npt.in in.lmp
[[ $# -ne 3 ]] && echo "Syntax: $(basename $0) template_file npt_input_file newname" && exit 1

template=$1
nptfile=$2
out=$3

# info from equilibration input file

atoms=$(grep "group ATOMS" $nptfile)
cores=$(grep "group CORES" $nptfile)
drudes=$(grep "group DRUDES" $nptfile)
fixdrude=$(grep "fix DRUDE" $nptfile)
fixshake=$(grep "fix SHAKE" $nptfile)
elements=$(grep "dump_modify.*element" $nptfile)

##  check includes for datafiles / pair coeffs and add relative paths
# rel path to file
# echo "$nptfile" | grep -q "/" && rel_to_npt=$(echo "$nptfile" | rev | cut -d/ -f2- | rev) || rel_to_npt="."
# # for ../in.lmp, rel_to_npt='..'
# # now check original npt input for any relative path to datafile
# rel_to_datafile=$(cat $nptfile | grep "pair-drude.lmp" | sed 's/include //;s/pair-drude.lmp//')
# then add the relative paths together

# modify template

cat $template |
  sed "s|pair-drude.lmp|$rel/pair-drude.lmp|" |
  sed "s|pdata.lmp|$rel/pdata.lmp|" |
  sed "s/group ATOMS.*/$atoms/" |
  sed "s/group CORES.*/$cores/" |
  sed "s/group DRUDES.*/$drudes/" |
  sed "s/fix DRUDE.*/$fixdrude/" |
  sed "s/fix SHAKE.*/$fixshake/" |
  sed "s/dump_modify.*element.*/$elements/" > $out
