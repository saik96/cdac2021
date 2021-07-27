gfortran -c mod_var.f90 -lfftw3 -L/home/sai/software/fftw3/lib -I/home/sai/software/fftw3/include 
gfortran -o serial.exe main.f90 mod_var.o -lfftw3 -L/home/sai/software/fftw3/lib -I/home/sai/software/fftw3/include 
gfortran -o ref.exe ref_code.f90 -lfftw3 -L/home/sai/software/fftw3/lib -I/home/sai/software/fftw3/include 
./serial.exe 
./ref.exe
python3 plotter.py
