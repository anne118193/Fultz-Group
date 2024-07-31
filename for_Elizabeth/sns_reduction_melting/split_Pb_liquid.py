# # import mantid algorithms, numpy and matplotlib
import mantid.simpleapi as msi
import matplotlib.pyplot as plt
from mantid import plots
import numpy as np
import json
import h5py
import os

# Things to change
#==========================
Eiguess = 50.0
IntegrationRange = [0.35, 0.75]
run_lst = [[201295]]
instrument='ARCS'
IPTS = 26201
#sp_dt = 180  #time spliting interval in s
Sp_parms = {'LogName':"BL18:SE:ND1:CH1:PV", 'LogValueInterval':5,'MinimumLogValue':301.973, 'MaximumLogValue':330.0,  'FilterLogValueByChangingDirection':'Decrease'} # temperature splitting #parameters
DGSdict = {}
DGSdict['EnergyTransferRange'] = [-50.0,0.1,50.0] #Energy Binning
Bining_2D = {'AlignedDim0':'|Q|,0.0,10,130', 'AlignedDim1':'DeltaE,-50,50,251'}
mde_pth = os.path.join('camille/Pb/50mev/ecuts','mdes_liquid_split','')
#========================================
dataloadstr='{}{:d}'.format(instrument,run_lst[0][0])
for idx in range(1,len(run_lst[0])):
    dataloadstr='{}+{}'.format(dataloadstr,run_lst[0][idx])
groupingFile="/SNS/ARCS/shared/autoreduce/ARCS_2X1_grouping.xml"
prepth = os.path.join('/SNS',instrument,'IPTS-{}'.format(IPTS),'shared','')
mde_dir = os.path.join(prepth,mde_pth)
ProcessedVanadium = "/SNS/ARCS/shared/autoreduce/vanadium_files/van201110.nxs"
msi.LoadNexus(Filename=ProcessedVanadium,OutputWorkspace="__VAN")
DGSdict['UseProcessedDetVan'] ='1'
DGSdict['DetectorVanadiumInputWorkspace'] = '__VAN'
HardMaskFile=''
msi.Load(Filename=dataloadstr, OutputWorkspace='IWS', LoadMonitors=False)
for idx,inrun in enumerate(run_lst[0]):
    if idx == 0:
      hmon = msi.LoadNexusMonitors('ARCS{:d}'.format(inrun))
    else:
      tmp = msi.LoadNexusMonitors('ARCS{:d}'.format(inrun))
      hmon += tmp 
msi.SetGoniometer('IWS','Universal') # add goniomenter invalidated by multiple file load.
Ei, T0 = msi.GetEiT0atSNS(hmon,Eiguess)
print('Ei = {} meV, T0 = {} (micros)'.format(Ei,T0))
DGSdict['SampleInputWorkspace'] = 'IWS'
DGSdict['SampleInputMonitorWorkspace'] = hmon
DGSdict['IncidentEnergyGuess']=Ei
DGSdict['UseIncidentEnergyGuess']='1'
DGSdict['TimeZeroGuess']=T0
    #DGSdict['EnergyTransferRange']=EnergyTransferRange
DGSdict['SofPhiEIsDistribution']='0' # keep events (need to then run RebinToWorkspace and ConvertToDistribution)
DGSdict['HardMaskFile']=HardMaskFile
DGSdict['GroupingFile']=groupingFile #choose 2x1 or some other grouping file created by GenerateGroupingSNSInelastic or GenerateGroupingPowder
DGSdict['IncidentBeamNormalisation']='None'
DGSdict['UseBoundsForDetVan']='1'
DGSdict['DetVanIntRangeHigh']=IntegrationRange[1]
DGSdict['DetVanIntRangeLow']=IntegrationRange[0]
DGSdict['DetVanIntRangeUnits']='Wavelength'
DGSdict['MedianTestLevelsUp']='1'
DGSdict['OutputWorkspace']='pre_split'
msi.DgsReduction(**DGSdict)
msi.GenerateEventsFilter(InputWorkspace='pre_split', OutputWorkspace='evf', InformationWorkspace='evf_info', **Sp_parms)
#TimeInterval=sp_dt)
#TempInterval=Sp_parms
msi.FilterEvents(InputWorkspace='pre_split', SplitterWorkspace='evf', OutputWorkspaceBaseName='split', InformationWorkspace='evf_info', FilterByPulseTime=True, GroupWorkspaces=True)
msi.RebinToWorkspace(WorkspaceToRebin="split",WorkspaceToMatch="split",OutputWorkspace="split2",PreserveEvents='0') #use if grouping
#msi.RebinToWorkspace(WorkspaceToRebin="pre_split",WorkspaceToMatch="pre_split",OutputWorkspace="split2",PreserveEvents='0') #use if doing a single run at fixed temp reduction
msi.NormaliseByCurrent(InputWorkspace="split2",OutputWorkspace="split2")
msi.ConvertToDistribution(Workspace="split2")
minvals,maxvals=msi.ConvertToMDMinMaxGlobal('split2_1','|Q|','Direct')
msi.ConvertToMD('split2',QDimensions='|Q|',dEAnalysisMode='Direct',MinValues=minvals,MaxValues=maxvals,OutputWorkspace='MD')
#msi.BinMD(InputWorkspace='MD', AlignedDim0='|Q|,0.0,11.9072999954,100', AlignedDim1='DeltaE,-10.0,50.0,100', OutputWorkspace='MD_rebinned')
#msi.BinMD(InputWorkspace='MD', AlignedDim0='|Q|,0.0,4,1', AlignedDim1='DeltaE,-10,50.0,100', OutputWorkspace='MD1_rebinned')
msi.BinMD(InputWorkspace='MD',  OutputWorkspace='SQE_rebinned', **Bining_2D)
#msi.BinMD(InputWorkspace='MD', AlignedDim0='|Q|,2.0,10,1', AlignedDim1='DeltaE,-50,50,100', 
#         OutputWorkspace='SE_rebinned')
hSQE = msi.mtd['SQE_rebinned']
try:
    os.listdir(mde_dir)
except:
    os.mkdir(mde_dir)
    
for idx in range(1,hSQE.getNumberOfEntries()):
    ws = hSQE.getItem(idx)
    fstr = mde_dir+'/'+ ws.getName()+'_md.h5'
    msi.SaveMD(Inputworkspace=ws, Filename=fstr, SaveHistory=False, SaveInstrument=False,
               SaveSample=False,SaveLogs=True)







