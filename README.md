# cdac2021
Codes that have been developed in CDAC 2021 -  CUDA Fortran
----------------------------------------------------------------------------------
----------------------------------------------------------------------------------

-----------------------------------------------
1)DCT for serial CPU (based on Makhoul 1980)
To run and plot, execute: bash bash_script.sh

Files:
- para.in contains resolution(n) , freq of testing cosine (p)
- mod_var.f90 contains variable declarations for main.f90
* main.f90 is the main file. It contains
	- subroutine redft10 which is the forward DCT
	- subroutine redft01 which is the inverse DCT
	- program main that can test these transforms. 
	  Reads n and p from para,in
	  and writes files:
		+ input.dat - contains testing function]
		+ output.dat - contains cosine transform
		+ output2.dat - contains inv cosine transform - should be input
* ref_code.f90 is DCT and inv DCT using FFTW3's REDFT10 and REDFT01 packages. 
  Reads n and p from para.in.
  It writes the corresponding files:
	+ ref_input.dat - contains testing function]
	+ ref_output.dat - contains cosine transform
	+ ref_output2.dat - contains inv cosine transform - should be input

- plotter.py is python3 program to plot the function, its dct, its inverse dct and related errors from .dat files. 
  Creates plot.png

NOTE: testing fn can be changed in the files main.f90 and ref_code.f90
	  currently testing with the radial component of Luo=Hou flow i.e. exp(-30(1-r^2)^4)

-----------------------------------------------
