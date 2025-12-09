#!/bin/bash
#
# Run klayout DRC on the SRAM test chip final version
# GDS is gf180mcu_ocd_sram_filled.gds.gz, top level cell name is
# gf180mcu_ocd_sram_top
#
echo ${PDK_ROOT:=/usr/share/pdk} > /dev/null
echo ${PDK:=gf180mcuD} > /dev/null

klayout -b -zz -r ${PDK_ROOT}/${PDK}/libs.tech/klayout/tech/drc/gf180mcu.drc -rd input=../gds/gf180mcu_ocd_sram_filled.gds.gz -rd report=../validate/sram_top_drc_klayout.lyrdb -rd feol=True -rd beol=True -rd conn_drc=True -rd wedge=True -rd run_mode=deep -rd thr=16 -rd topcell=gf180mcu_ocd_sram_top

echo "Done!"
exit 0
