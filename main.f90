program serial_dct_dft
      
      use,intrinsic::iso_c_binding 
      implicit none
      include 'fftw3.f03'

      integer,parameter::n=32
      integer,parameter::nhf=int(n/2.)-1
      double precision,dimension(n)::x,y,F,G
      double complex,dimension(n)::H,Yr,Yk
      type(C_PTR)::pfor,pinv
      double precision,parameter::pi=4*atan(1.0d0)
      double precision::rk,ik,scl,p=4
      integer::k,r

      !plan init
      CALL dfftw_plan_dft_1d(pinv,n,Yk,Yr,FFTW_BACKWARD,FFTW_ESTIMATE)
   
      F=0.0d0
      G=0.0d0
      y=0.0d0
      x=0.0d0
      H=complex(0.0d0,0.0d0)
      Yr=complex(0.0d0,0.0d0)
      Yk=complex(0.0d0,0.0d0)

      scl=pi/float(n)

      !declare f to be cosine transformed
      do k=0,n-1
        x(k+1)=cos(p*scl*(k+0.5))
      enddo
   
      !aux fn y for dct fwd transform
      do k=0,nhf 
        y(k+1)=x(int(2*k)+1)
        y(n-1-k+1)=x(int(2*k)+1+1)
      enddo
     
      open(unit=100,file='input.dat',status='unknown')
      do k=0,n-1
        write(100,*)k,x(k+1),y(k+1)
        Yk(k+1)=complex(y(k+1),0.0d0)  ! do not comment this
      enddo
      close(100)
      
      !c2c IDFT of real space data!
      call dfftw_execute_dft(pinv,Yk,Yr)
      
      !phase shift
      do r=0,n-1
        H(r+1)=Yr(r+1)*complex(cos(0.5*scl*r),sin(0.5*scl*r)) 
      enddo

      do r=0,nhf
        F(r+1)=real(H(r+1))
        F(n-r-1)=aimag(H(r+1))
      enddo
    
      !to match FFTW3-REDFT10
      F(:)=F(:)*2.0d0

     open(unit=200,file='output.dat',status='unknown')
      do r=0,n-1
        write(200,*)r,F(r+1)
      enddo
     close(200)

      call dfftw_destroy_plan(pinv)
end program
