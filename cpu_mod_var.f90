module mod_var

      use,intrinsic::iso_c_binding 
      implicit none
      include 'fftw3.f03'
      save

      integer*8::n,nhf,k,r
      double precision,parameter::pi=4*atan(1.0d0)
      double precision::p,scl

      double precision,allocatable,dimension(:)::x,F
      double complex,allocatable,dimension(:)::Yk,Yr
      type(C_PTR)::pfor,pinv

end module 

