program dct_test
    use,intrinsic::iso_c_binding 
    implicit none
      include 'fftw3.f03'

      integer::n
    !  real(C_DOUBLE),pointer::f(:),g(:)
      double precision,allocatable,dimension(:)::f,g
      type(C_PTR)::pfor,pinv,p1,p2
      double precision,parameter::pi=4*atan(1.0d0)
      double precision::x,p,scl
      integer::m,i
    
      !read input params i.e  resolution and freq
      open(unit=1000,file='para.in',status='old')
      read(1000,*)n,p
      close(1000)
    
      scl=pi/float(n)

      allocate(f(n),g(n))
      f=0.0d0
      g=0.0d0
!      !FFTW alloc for faster mem access
!      p1=fftw_alloc_real(int(n,C_SIZE_T))
!      p2=fftw_alloc_real(int(n,C_SIZE_T))
!    
!      call c_f_pointer(p1,f,[n])
!      call c_f_pointer(p2,g,[n])

      !plan init
      CALL dfftw_plan_r2r_1d(pfor,n,f,g,FFTW_REDFT10,FFTW_ESTIMATE)
      CALL dfftw_plan_r2r_1d(pinv,n,g,f,FFTW_REDFT01,FFTW_ESTIMATE)

     open(unit=100,file='ref_input.dat',status='unknown')
      do i=0,n-1
      !  f(i+1)=cos(p*scl*(i+0.5))
        f(i+1)=exp(-30*(1-(i*1/dble(n))**2)**4) !LH test fn
        write(100,*)i,f(i+1)
      enddo
     close(100)

      call dfftw_execute_r2r(pfor,f,g)
      g=g/dble(n)
     
     open(unit=200,file='ref_output.dat',status='unknown')
      do i=1,n
        write(200,*)i-1,g(i)
      enddo
     close(200)

     call dfftw_execute_r2r(pinv,g,f)
      f=f/2.0d0
     open(unit=300,file='ref_output2.dat',status='unknown')
      do i=1,n
        write(300,*)i-1,f(i)
      enddo
     close(300)


      call dfftw_destroy_plan(pfor,pinv)
end program
