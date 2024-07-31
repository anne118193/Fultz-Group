import numpy as np
import argparse
import hashlib
from argparse import ArgumentParser
import os.path
import os
import shutil
from os import path
import subprocess as sp

# outfile= name of output file
def gen_cell_orthogonal(a,outfile):    
    c = a*1.9516385330561992 # fixed c/a ratio
    header = """# Zn
 8 atoms
 1 atom types
 0   {0:.16f}      xlo xhi
 0   {1:.16f}      ylo yhi
 0   {2:.16f}      zlo zhi
   0.0000000000000000        0.0000000000000000        0.0000000000000000      xy xz yz
 Atoms
    \n""".format(2*a,a*3**(1/2.),c) 
    
    footer = """          1           1   {0:.16f}        {1:.16f}        {2:.16f}
           2           1   {3:.16f}       {4:.16f}        {2:.16f}
           3           1   0.0000000000000000        {1:.16f}         {2:.16f}
           4           1   {5:.16f}       {4:.16f}        {2:.16f}
           5           1   {3:.16f}        {6:.16f}         {7:.16f}
           6           1   {5:.16f}        {6:.16f}        {7:.16f}
           7           1   {0:.16f}         {8:.16f}        {7:.16f}
           8           1   0.0000000000000000        {8:.16f}        {7:.16f}""".format(a,a/3**(1/2.)*2,c*3/4,a*3/2,a/3**(1/2.)/2,a/2,a/3**(1/2.)*5/2,c/4,a/3**(1/2.))

    with open(outfile, 'w') as f:
        f.write(header)
        f.write(footer)

def remove_files(path1, ph):
    
    max_step=sp.check_output(f"ls {path1}/*{ph}* | cut -d'/' -f3 | cut -d'.' -f1",shell=True).decode("utf-8").split("\n") 
    max_step.remove("")
    print(max_step)
    max_step = max(list(map(int, max_step)))
    if ph == 'sol':
        sp.run(f"find {path1}* \! -name '{max_step}.sol.equil' -and \! -name '*liq*' -delete", shell = True)
    else:
        sp.run(f"find {path1}* \! -name '{max_step}.liq.equil' -and \! -name '*sol*' -delete", shell = True)
    pass

def cmd_run(T, V, cut, side, RunSteps, traj, n, seed=-1):
    ph = "liq"
    seed = int(sp.check_output('echo "V_{}_cut_{}_side_{}_T_{}_traj_{}" | md5sum | od -An -N3 -i | xargs'.format(V, cut, side, T, 1),shell=True)[:-1].decode("utf-8"))
    print('V={} cut={} side={} T={} phase={} traj={}'.format(V, cut, side, T, ph, traj))
    
    system_line = f"srun -n 128 --cpu-bind=cores shifter lmp_mpich"

    out_path = f"data_{seed}"
    path1 = f"{out_path}/traj"
    inp_line='{} -v SEED {} -v T {} -v V {} -v c {} -v SIDE {} -v TRAJ {}'.format(system_line, seed, T, V, cut, side, traj)   
    print(path1)
    max_existed_step = sp.check_output("ls {}/*{}* | cut -d'/' -f3 | cut -d'.' -f1".format(path1,ph),shell=True).decode("utf-8").split("\n")
    
    max_existed_step.remove("")
    print(max_existed_step, len(max_existed_step))

    if path.exists(path1) and len(max_existed_step) >= 1:

        max_existed_step = max(list(map(int, max_existed_step)))
        remove_files(path1, ph)
        if max_existed_step >= (RunSteps+max_existed_step):
            return print("{}{} exists".format(path1,max_existed_step))
        else:         
            inp = inp_line+' -v re_step {} -v PH {} -v EXTRASTEPS {} -v CS {} -log none -in READ.in'.format(max_existed_step,ph,RunSteps, max_existed_step)
            return [inp]       
    else:
        os.mkdir(f"{out_path}")
        os.mkdir(f"{path1}")
        f = open(f"{out_path}/seed.txt", 'a')
        f.write(f"{T} {V} {cut} {side} {seed}\n")
        f.close()

        a = 2.75
        gen_cell_orthogonal(a,f"{out_path}/supercell_lammps")
        
        inp = inp_line + ' -v RUNSTEPS {} -in LIQ.in'.format(RunSteps) 
        return [inp]

def gen_job_lines(data, Nstep):
    sys_lines = []
    for tvcs in data:
        sys_lines += cmd_run(T=tvcs[0], V=tvcs[1], cut=tvcs[2], side=tvcs[3], RunSteps=Nstep, traj=tvcs[4], n=1)

    return sys_lines
