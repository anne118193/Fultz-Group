import sys

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
    """.format(2*a,a*3**(1/2.),c) 
    
    footer = """           1           1   {0:.16f}        {1:.16f}        {2:.16f}
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

if __name__ == "__main__":
    gen_cell_orthogonal(float(sys.argv[1]), sys.argv[2])
