#!/bin/env python3
#
# Annotate the port list for the chip_half_frame.
# This depends on each label being a port but ports
# not in order.  Normally one would use "readspice"
# to do this, but that only works with SPICE and
# not verilog.  Easiest solution for hundreds of
# pins is to code it.
#
#

import io
import sys
import re

pindict = {}
pindict['DVDD'] = 1
pindict['DVSS'] = 2
pindict['VDD'] = 3
pindict['VSS'] = 4
nextidx = 5
for i in range(45,-1,-1):
    pindict['bidir_PAD[' + str(i) + ']'] = nextidx
    nextidx = nextidx + 1

for i in range(4,-1,-1):
    pindict['analog_PAD[' + str(i) + ']'] = nextidx
    nextidx = nextidx + 1

for i in range(4,-1,-1):
    pindict['input_PAD[' + str(i) + ']'] = nextidx
    nextidx = nextidx + 1

pindict['clk_PAD'] = nextidx
nextidx = nextidx + 1
pindict['rst_n_PAD'] = nextidx
nextidx = nextidx + 1

for i in range(45,-1,-1):
    pindict['bidir_CS[' + str(i) + ']'] = nextidx
    nextidx = nextidx + 1

for i in range(45,-1,-1):
    pindict['bidir_PU[' + str(i) + ']'] = nextidx
    nextidx = nextidx + 1

for i in range(45,-1,-1):
    pindict['bidir_PDRV0[' + str(i) + ']'] = nextidx
    nextidx = nextidx + 1

for i in range(45,-1,-1):
    pindict['bidir_PDRV1[' + str(i) + ']'] = nextidx
    nextidx = nextidx + 1

for i in range(45,-1,-1):
    pindict['bidir_ANA[' + str(i) + ']'] = nextidx
    nextidx = nextidx + 1

for i in range(45,-1,-1):
    pindict['bidir_PD[' + str(i) + ']'] = nextidx
    nextidx = nextidx + 1

for i in range(45,-1,-1):
    pindict['bidir_IE[' + str(i) + ']'] = nextidx
    nextidx = nextidx + 1

for i in range(45,-1,-1):
    pindict['bidir_SL[' + str(i) + ']'] = nextidx
    nextidx = nextidx + 1

for i in range(45,-1,-1):
    pindict['bidir_A[' + str(i) + ']'] = nextidx
    nextidx = nextidx + 1

for i in range(45,-1,-1):
    pindict['bidir_OE[' + str(i) + ']'] = nextidx
    nextidx = nextidx + 1

for i in range(45,-1,-1):
    pindict['bidir_Y[' + str(i) + ']'] = nextidx
    nextidx = nextidx + 1

for i in range(51,-1,-1):
    pindict['loopback_one[' + str(i) + ']'] = nextidx
    nextidx = nextidx + 1

for i in range(51,-1,-1):
    pindict['loopback_zero[' + str(i) + ']'] = nextidx
    nextidx = nextidx + 1

for i in range(4,-1,-1):
    pindict['input_PU[' + str(i) + ']'] = nextidx
    nextidx = nextidx + 1

for i in range(4,-1,-1):
    pindict['input_PD[' + str(i) + ']'] = nextidx
    nextidx = nextidx + 1

for i in range(4,-1,-1):
    pindict['input_Y[' + str(i) + ']'] = nextidx
    nextidx = nextidx + 1

pindict['clk_PU'] = nextidx
nextidx = nextidx + 1
pindict['clk_PD'] = nextidx
nextidx = nextidx + 1
pindict['clk_Y'] = nextidx
nextidx = nextidx + 1
pindict['rst_n_PU'] = nextidx
nextidx = nextidx + 1
pindict['rst_n_PD'] = nextidx
nextidx = nextidx + 1
pindict['rst_n_Y'] = nextidx

# That's all the pins!

olines = []
linenum = 1
with open('chip_half_frame.mag', 'r') as ifile:
    mlines = ifile.read().splitlines()
    for mline in mlines:
        newline = mline
        if newline.startswith('rlabel'):
            tokens = newline.split(' ')
            label = tokens[-1]
        elif newline.startswith('flabel'):
            tokens = newline.split(' ')
            label = tokens[-1]
        elif newline.startswith('port'):
            tokens = newline.split()
            try:
                portnum = pindict[label]
            except:
                print('Error: expected known pin name, got ' + label)
                print('Diagnostic: complete line is "' + newline + '"')
                print('Line number: ' + str(linenum))
            else:
                portstr = str(portnum)
                tokens[1] = portstr
                newline = ' '.join(tokens)
            label = None
        olines.append(newline)
        linenum = linenum + 1

with open('chip_half_frame_annotated.mag', 'w') as ofile:
    for oline in olines:
        print(oline, file=ofile)

print('Done!')
sys.exit(0)
