#!/bin/bash
#
# Run layout GDS generation on gf180mcu_ocd_sram_test
# Run this script from the magic/ directory
#
echo ${PDK_ROOT:=/usr/share/pdk} > /dev/null
echo ${PDK:=gf180mcuD} > /dev/null

echo "Generating GDS for gf180mcu_ocd_sram_test"

magic -dnull -noconsole -rcfile ${PDK_ROOT}/${PDK}/libs.tech/magic/${PDK}.magicrc << EOF
drc off
crashbackups stop
locking disable
load gf180mcu_ocd_sram_top
addpath wafer_space
select top cell
snap int
gds compress 9
gds write gf180mcu_ocd_sram_top
quit -noprompt
EOF
mv gf180mcu_ocd_sram_top.gds.gz ../gds/
echo "Done!"
exit 0
