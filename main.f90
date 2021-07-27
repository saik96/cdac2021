program serial_dct_dft
      
      use mod_var
      implicit none
        
      !read input params i.e  resolution and freq
      open(unit=1000,file='para.in',status='old')
      read(1000,*)n,p
      close(1000)

      !constants, alloc
      nhf=int(n/2.) -1
      scl=pi/dble(n)
      allocate(F(n),x(n))
      allocate(Yr(n),Yk(n))
      F=0.0d0
      x=0.0d0
      Yk=0.0d0
      Yr=0.0d0

      CALL dfftw_plan_dft_1d(pinv,n,Yk,Yr,FFTW_BACKWARD,FFTW_ESTIMATE)
      CALL dfftw_plan_dft_1d(pfor,n,Yr,Yk,FFTW_FORWARD,FFTW_ESTIMATE)

      !declare function x to be cosine transformed
      do k=0,n-1
 !       x(k+1)=cos(p*scl*(k+0.5))
        x(k+1)=exp(-30*(1-(k*1/dble(n))**2)**4) !LH test fn
      enddo

     open(unit=100,file='input.dat',status='unknown')
      do k=0,n-1
        write(100,*)k,x(k+1)
      enddo
     close(100)
     
     !fwd dct
      call redft10(x,F)

     open(unit=200,file='output.dat',status='unknown')
      do r=0,n-1
        write(200,*)r,F(r+1)
      enddo
     close(200)
     
     !inv dct
     call redft01(F,x)

     open(unit=300,file='output2.dat',status='unknown')
      do k=0,n-1
        write(300,*)k,x(k+1)
      enddo
     close(300)
   
     !dealloc and destroy
      call dfftw_destroy_plan(pfor)
      call dfftw_destroy_plan(pinv)

end program


subroutine redft10(x_dum,F_dum)
      use mod_var
      implicit none

      double precision,dimension(n),intent(in)::x_dum
      double precision,dimension(n),intent(inout)::F_dum
      double precision,dimension(n)::y,G
      double complex,dimension(n)::H 

      F_dum(:)=0.0d0
      y(:)=0.0d0
      G(:)=0.0d0
      H(:)=complex(0.0d0,0.0d0); Yr(:)=complex(0.0d0,0.0d0); Yk(:)=complex(0.0d0,0.0d0)
      !aux fn y for dct fwd transform
      do k=0,int((n-1)/2.)
        y(k+1)=x_dum((2*k)+1)
       ! print*,k+1,2*k+1
      enddo
      do k=int((n+1)/2.),n-1
        y(k+1)=x_dum((2*n-2*k-1+1))
     !   print*,k+1,2*n-2*k-1+1
      enddo
     
      do k=0,n-1
      Yk(k+1)=complex(y(k+1),0.0d0)  ! do not comment this
      enddo
      
      !c2c IDFT of real space data!
      call dfftw_execute_dft(pfor,Yk,Yr)
      
      !phase shift
      do r=0,n-1
        H(r+1)=Yr(r+1)*2*complex(cos(0.5d0*scl*r),-sin(0.5d0*scl*r)) 
      enddo
    
      F_dum(:)=0.0d0

 !   do r=1,n
 !       print*,r,H(r)
 !   enddo
  
    do r=0,floor((n)/2.)
        F_dum(r+1)=real(H(r+1))
            if( n-r+1 <= n) then
                F_dum(n-r+1)=-aimag(H(r+1))
              !  print*,r+1,n-r+1
            endif
       ! if (r==0) then
       !     F_dum(r+1)=F_dum(r+1)/sqrt(2.)
       ! endif
      enddo
    
      !to match FFTW3-REDFT10
      F_dum(:)=F_dum(:)/dble(n)

end subroutine


subroutine redft01(F_dum,x_dum)
      use mod_var
      implicit none

      double precision,dimension(n),intent(inout)::x_dum
      double precision,dimension(n),intent(in)::F_dum
      double precision::theta

      do r=0,n-1
        Yr(r+1)=F_dum(r+1)*complex(cos(scl*r*0.5),sin(scl*r*0.5))
        if (r==0) then
            Yr(r+1)=Yr(r+1)/(2.)
        endif
      enddo
      
      !c2c IDFT of real space data!
      call dfftw_execute_dft(pinv,Yr,Yk)
    
      x_dum(:)=0.0d0
      do k=0,nhf
        theta=2*k*scl*r
        x_dum(int(2*k)+1)=real(Yk(k+1))
      !  print*,2*k+1,k+1
      enddo

     do k=nhf+1,n-1
        x_dum(2*n-2*k-1+1)=real(Yk(k+1))
       ! print*,2*n-2*k,k+1
    enddo

    
end subroutine
