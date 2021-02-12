#!/bin/sh

fftool 20 ch.xyz 20 ac.xyz 100 swm4-ndp.xyz -b 25
packmol < pack.inp                                        
fftool 20 ch.xyz 20 ac.xyz 100 swm4-ndp.xyz -b 25 -l
polarizer -f cdrude.dff data.lmp pdata.lmp
gsed -i 's/0.000  # M/1e-16  # M/' pdata.lmp # python reads 1e-16 as 0 (massless site in swm4-ndp)  # sed on linux, not gsed
input_polariser in.lmp # adds coul/tt damping to any atom types containing H and O
# pair_scaler

rm *pack.xyz 
