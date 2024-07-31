import os
import numpy as np
import h5py
import histogram.hdf as hh
import histogram as H
from matplotlib import pyplot as plt
from scipy.interpolate import make_interp_spline as spl
from scipy.signal import savgol_filter
from multiphonon.sqe import plot as plot_sqe
import multiphonon.backward.sqe2dos as s2d
from multiphonon.flutils import MDH2Histo
import json
import copy
import sys
import glob

save_fig= True
if "fsave" in sys.argv:
    save_fig = True
figpath='figures'
if save_fig:
    try: 
        os.listdir('./{}'.format(figpath))
    except FileNotFoundError :
        os.mkdir('./{}'.format(figpath))



mtfrac = 1.0
#load backgroundfiles
bkg_fnames = glob.glob('./mdes_liquid_split/*_bkg_md.h5')
mtiqe = {fname.split('./mdes_liquid_split/')[1].split('_bkg')[0]:MDH2Histo(fname) for fname in bkg_fnames}
#load data files
datiqe = {fname:MDH2Histo('./mdes_liquid_split/{}_md.h5'.format(fname))for fname in mtiqe.keys()}

pc_bkg = {}
T_bkg = {}
pc ={}
T = {}
for fn in bkg_fnames:
    d_ky = fn.split('./mdes_liquid_split/')[1].split('_bkg')[0]
    with h5py.File(fn) as fh:
       pc_bkg[d_ky] = fh['MDHistoWorkspace/experiment0/logs/gd_prtn_chrg/value'][:]

       T_bkg[d_ky] = np.mean(fh['MDHistoWorkspace/experiment0/logs/BL18:SE:ND1:CH1:PV/value'][:])
    fns = './mdes_liquid_split/{}_md.h5'.format(d_ky)
    with h5py.File(fns) as fh:
        pc[d_ky] = fh['MDHistoWorkspace/experiment0/logs/gd_prtn_chrg/value'][:]
        T[d_ky] = np.mean(fh['MDHistoWorkspace/experiment0/logs/BL18:SE:ND1:CH1:PV/value'][:])
    print(T[d_ky])
    print(T_bkg[d_ky])

diffiqe = {}
diffie ={}
for fl in mtiqe.keys():
    nanflt = np.isnan(mtiqe[fl].I)
    mtiqe[fl].I[nanflt] = 0.0
    mtiqe[fl].E2[nanflt] = 0.0
    datiqe[fl].I[nanflt] = 0.0
    datiqe[fl].E2[nanflt] = 0.0
    mtiqe[fl].I=mtiqe[fl].I
    datiqe[fl].I=datiqe[fl].I
    f,ax = plt.subplots(nrows=2,ncols=2,figsize=(8,8))
    ax = ax.flatten()
    ch={}
    ch[0] = ax[0].pcolorfast(datiqe[fl].Q,datiqe[fl].E,datiqe[fl].I.T)
    ch[0].set_clim([0,2e-2])
    ch[1] = ax[1].pcolorfast(mtiqe[fl].Q,mtiqe[fl].E,mtiqe[fl].I.T)
    ch[1].set_clim([0,2e-2])
    f.colorbar(ch[1],ax=ax[1])
    mts = copy.copy(mtiqe[fl])
    mts*=(mtfrac, 0)
    diffiqe[fl] = datiqe[fl]-mts
    diffie[fl] = diffiqe[fl][(1.5,9.5),()].sum('Q')
    ch[2] = ax[2].pcolorfast(diffiqe[fl].Q,diffiqe[fl].E,diffiqe[fl].I.T)
    ch[2].set_clim([0,2e-2])
    ax[3].errorbar(diffie[fl].axes()[0].binCenters(), diffie[fl].I, yerr=np.sqrt(diffie[fl].E2))
    ax[3].set_xlabel('$\Delta E (meV)$')
    ax[3].set_yscale('log')
    f.suptitle('{} T={:0.0f}K'.format(fl,T[fl]))
    if save_fig:
        f.savefig(os.path.join(figpath,'T_{:0.0f}K.png'.format(T[fl])))
    f.show()

#calculate dos
#clrs = plt.cm.jet(np.linspace(0,1,len(mtiqe.keys())))
#Tmin = np.array(list(T.values())).min()
#Tmax = np.array(list(T.values())).max()
#DT = Tmax-Tmin
#
#
#iterdos={}
#dos = {n: None for n in mtiqe.keys()}
#Ecuts = {n:40 for n in mtiqe.keys()}
#elastic_cuts = {n:(-10.0,10.0) for n in mtiqe.keys()}
#
#M_Sn = 78.96
#C_msval = 0.003
#projectdir = './dos_calculations'
#workdirs = {n:'work_{}_temp'.format(n) for n in mtiqe.keys()}
#idos = None # start with out an initial guess for the dos
#
#f3, ax3 = plt.subplots(figsize=(10, 8))
#lstky = None
#for idx1,ky in enumerate(mtiqe.keys()):
#    if lstky !=None:
#        idos = dos[lstky]
#                #print(idos) 
#    lstky = ky 
#    iterdos[ky] = s2d.sqe2dos(copy.copy(diffiqe[ky]), T=T[ky], Ecutoff=Ecuts[ky], 
#                            elastic_E_cutoff=elastic_cuts[ky],
#                            M=M_Sn, C_ms=C_msval, Ei=50.0,
#                            initdos=idos, workdir=os.path.join(projectdir, workdirs[ky]),update_strategy_weights = (0.5,0.5))
#    doslist = list(iterdos[ky])
#    dos[ky] = doslist[-1].copy()
#    ax3.errorbar(dos[ky].E, dos[ky].I,yerr=np.sqrt(dos[ky].E2),fmt ='o', mfc='None',color=clrs[int(np.floor((len(mtiqe.keys())-1)*(T[ky]-Tmin)/DT))], label= "{:0.0f}".format(T[ky]) )
#    lncl = ax3.lines[-1].get_color()
#    ax3.plot(dos[ky].E,savgol_filter(dos[ky].I,5,2),color=lncl)
#ax3.set_xlabel('Energy (meV)')
#ax3.set_ylabel('$g(\omega )$')
#ax3.set_xlim(0, 50)
#ax3.legend(title='T')
#ax3.set_title('Sn')
#if save_fig:
#    f3.savefig(os.path.join(figpath,'dos.png'))
#f3.show()
