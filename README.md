# pol-il-drudes

Polarisabilities calculated using M062X/Sadlej-pVTZ, with a field of 0.008 au
applied in each dimension. Analysis of gaussian checkpoint files was carried
out using Andrew Stone's [gdma software](http://www-stone.ch.cam.ac.uk/programs.html), 
with helper scripts found [here](https://github.com/tommason14/scripts/tree/master/chem/polarisabilities).

The xyz and ff files are to be used with [fftool](https://github.com/agiliopadua/fftool), and the dff files 
should be used with the `polarizer` script in the `fftool` repository.
