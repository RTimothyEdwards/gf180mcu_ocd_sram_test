#!/bin/sh
#
# Run LVS on the SRAM test chip (gf180mcu_ocd_sram_test)
#
echo ${PDK_ROOT:=/usr/share/pdk} > /dev/null
echo ${PDK:=gf180mcuD} > /dev/null

# export NETGEN_COLUMNS=150
export NETGEN_COLUMNS=75

netgen -batch source lvs_script.tcl
