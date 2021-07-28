
import matplotlib.pyplot as plt
import numpy as np
dpi_p=100
flag=2
if flag==1:

    linewidth3=1 #upto 0.18 mm
    f1=plt.figure(num=1, figsize=(2*5,3*3), dpi=dpi_p, facecolor='w', edgecolor='k')

    ax1=f1.add_subplot(3,2,1)
    ax2=f1.add_subplot(3,2,3)
    ax3=f1.add_subplot(3,2,5)
    ax1a=f1.add_subplot(3,2,2)
    ax2a=f1.add_subplot(3,2,4)
    ax3a=f1.add_subplot(3,2,6)

    params=np.loadtxt('para.in')
    i1=np.loadtxt('input.dat')
    o1=np.loadtxt('output.dat')
    o2=np.loadtxt('output2.dat')
    ri1=np.loadtxt('ref_input.dat')
    ro1=np.loadtxt('ref_output.dat')
    ro2=np.loadtxt('ref_output2.dat')

    ax1.plot(ri1[:,0],ri1[:,1],'r.-')
    ax1.plot(i1[:,0],i1[:,1],'b.')
    ax1.set_title('input')
    ax1a.plot(abs(ri1[:,1]-i1[:,1]),'k')

    ax2.plot(ro1[:,0],ro1[:,1],'r.-')
    ax2.plot(o1[:,0],o1[:,1],'b.')
    ax2.set_title('redft10')
    ax2a.set_title('log error')
    ax2a.plot(abs(ro1[:,1]-o1[:,1]),'k')

    ax3.plot(ro2[:,0],ro2[:,1],'r',label='FFTW DCT')
    ax3.plot(o2[:,0],o2[:,1],'b.',label='Nara DCT')
    ax3.set_title('redft01')
    ax3a.semilogy(abs(o2[:,1]-i1[:,1]),'b.-')
    ax3a.semilogy(abs(ro2[:,1]-ri1[:,1]),'r.-')
    ax3.legend()
    print(params[0],max(abs(ro2[:,1]-ri1[:,1])),max(abs(o2[:,1]-i1[:,1])))
    plt.tight_layout()
    plt.savefig('plot.png')
    #plt.show()

if flag==2:

    #rescomp plot
    errs=np.loadtxt('res_error.out')
    f1= plt.figure(1,figsize=(5,3),dpi=dpi_p)
    ax1=f1.add_subplot(1,1,1)
    ax1.plot(errs[:,0],errs[:,1],'r.-',label='FFTW3 DCT')
    ax1.plot(errs[:,0],errs[:,2],'b.-',label='NARA DCT')
    ax1.set_ylabel('max$(|\mathcal{C}^{-1} \mathcal{C} (f) - f|)$')
    ax1.set_xlabel('N')
    ax1.set_title('Resolution scaling of DCT errors')
    plt.savefig('errs_plot_dct.png')


