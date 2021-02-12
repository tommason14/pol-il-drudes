#!/usr/bin/env bash

# use as modify_nemd_input.sh datafile nemd.template in.lmp
[[ $# -ne 3 ]] &&
  echo "Syntax: $(basename $0) template_file datafile newname" &&
  echo "NB: Check that the path to pair-drude.lmp in the input file is correct" &&
  exit 1

template=$1
datafile=$2
out=$3

# info from equilibration input file

atoms=$(
  sed -n '/Atoms/,/Bonds/p' $datafile |
  grep -v 'DP$' |
  grep '^\s*[0-9]' |
  awk '{print $3}' |
  sort -nu |
  tr '\n' ' ' |
  sed 's/ $//'
)

cores=$(
  sed -n '/Atoms/,/Bonds/p' $datafile |
  grep 'DC$' |
  awk '{print $3}' |
  sort -nu |
  tr '\n' ' ' |
  sed 's/ $//'
)

drudes=$(
  sed -n '/Atoms/,/Bonds/p' $datafile |
  grep 'DP$' |
  awk '{print $3}' |
  sort -nu |
  tr '\n' ' ' |
  sed 's/ $//'
)

waters=$(
  sed -n '/Atoms/,/Bonds/p' $datafile |
  grep '^\s*[0-9]' |
  grep -v "DP" |
  grep -i water |
  awk '!seen[$3]++ {print $3}' |
  tr '\n' ' ' |
  sed 's/ $//'
)

fixdrude=$(
  sed -n '/Masses/,/Bond Coeffs/p' $datafile |
  grep '^\s*[0-9]' |
  awk '{if($NF=="DC") {print "C"} else if ($NF=="DP") {print "D"} else {print "N"}}' |
  tr '\n' ' ' |
  sed 's/ $//'
)

fixshake=$(
  sed -n '/Bond Coeffs/,/Angle Coeffs/p' $datafile |
  grep '^\s*[0-9]' |
  awk '{print $1,$NF}' |
  grep ' H\|-H' |
  grep -v "Hw" | # water fixed using fix rigid, not fix shake
  awk '{print $1}' |
  tr '\n' ' ' |
  sed 's/ $//'
)

elements=$(lammps_print_elements.py $datafile) # too hard to write in shell script...

# modify template

cat $template |
  sed "s|pdata.lmp|../pdata.lmp|" |
  sed "s/group ATOMS.*/group ATOMS type $atoms/" |
  sed "s/group CORES.*/group CORES type $cores/" |
  sed "s/group DRUDES.*/group DRUDES type $drudes/" |
  sed "s/group WATER.*/group WATER type $waters/" |
  sed "s/fix DRUDE.*/fix DRUDE all drude $fixdrude/" |
  sed "s/fix SHAKE.*/fix SHAKE ATOMS shake 0.0001 20 0 b $fixshake/" |
  sed "s/dump_modify.*element.*/dump_modify d1 element $elements/" > $out
