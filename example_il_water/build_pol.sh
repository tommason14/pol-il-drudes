#!/bin/sh

fftool 400 ch.xyz 400 dhp.xyz 1116 swm4-ndp.xyz -b 58
packmol < pack.inp                                        
fftool 400 ch.xyz 400 dhp.xyz 1116 swm4-ndp.xyz -b 58 -l
polarizer -f cdrude.dff data.lmp pdata.lmp
sed -i 's/0.000  # M/1e-16  # M/' pdata.lmp # python reads 1e-16 as 0 (massless site in swm4-ndp) 
input_polariser in.lmp # adds coul/tt damping to any atom types containing H and O
pair_scaler

rm *pack.xyz 
