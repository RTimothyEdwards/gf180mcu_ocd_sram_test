#!/bin/bash
#
# Run layout extraction on the SRAM test chip
#
echo ${PDK_ROOT:=/usr/share/pdk} > /dev/null
echo ${PDK:=gf180mcuD} > /dev/null

echo "Running netlist extraction on gf180mcu_ocd_sram_test2"
magic -dnull -noconsole -rcfile ${PDK_ROOT}/${PDK}/libs.tech/magic/${PDK}.magicrc << EOF
load gf180mcu_ocd_sram_test2
select top cell
extract path extfiles
extract no all
# extract do unique notopports
extract do unique
extract all
ext2spice lvs
ext2spice -p extfiles -o ../netlist/layout/gf180mcu_ocd_sram_test2.spice
quit -noprompt
EOF
rm -rf extfiles
echo "Done"
