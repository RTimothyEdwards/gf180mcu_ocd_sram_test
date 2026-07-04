#!/bin/bash
#
# Run klayout DRC on the 3.3V PoR
# GDS is por_3v3_selfbiased.gds.gz, top level cell name is
# por_3v3_selfbiased
#
echo ${PDK_ROOT:=/usr/share/pdk} > /dev/null
echo ${PDK:=gf180mcuD} > /dev/null

klayout -b -zz -r ${PDK_ROOT}/${PDK}/libs.tech/klayout/tech/drc/gf180mcu.drc -rd input=../gds/por_3v3_selfbiased.gds.gz -rd report=../validate/sram_top_drc_klayout.lyrdb -rd feol=True -rd beol=True -rd conn_drc=True -rd wedge=True -rd run_mode=deep -rd thr=16 -rd topcell=por_3v3_selfbiased

echo "Done!"
exit 0
