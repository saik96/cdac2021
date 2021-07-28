for n in {4..15}
do 
	echo "$((2**n))   1" > para.in 
	cat para.in
	gfortran -c cpu_mod_var.f90 -lfftw3 -L/home/sai/software/fftw3/lib -I/home/sai/software/fftw3/include 
	gfortran -o cpu_serial.exe cpu_main.f90 cpu_mod_var.o -lfftw3 -L/home/sai/software/fftw3/lib -I/home/sai/software/fftw3/include 
	gfortran -o cpu_ref.exe cpu_ref_code.f90 -lfftw3 -L/home/sai/software/fftw3/lib -I/home/sai/software/fftw3/include 
	./cpu_serial.exe  
	./cpu_ref.exe
	python3 plotter.py >> cpu_res_error.out
done
