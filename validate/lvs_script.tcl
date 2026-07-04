# Tcl script for setting up LVS for the gf180mcu_ocd_sram_test chip
if {[catch {set PDK_ROOT $::env(PDK_ROOT)}]} {set PDK_ROOT /usr/share/pdk} 
if {[catch {set PDK $::env(PDK)}]} {set PDK gf180mcuD}

# Read from defs.v to set the netlist format to verilog as well as
# setting global definitions needed, like USE_POWER_PINS.
set circuit2 [readnet spice ${PDK_ROOT}/${PDK}/libs.ref/gf180mcu_ocd_io/spice/gf180mcu_ocd_io.spice]
readnet spice ${PDK_ROOT}/${PDK}/libs.ref/gf180mcu_as_sc_mcu7t3v3/spice/gf180mcu_as_sc_mcu7t3v3.spice $circuit2
readnet spice ${PDK_ROOT}/${PDK}/libs.ref/gf180mcu_ocd_ip_sram/spice/gf180mcu_ocd_ip_sram__sram1024x8m8wm1.spice $circuit2
readnet spice ${PDK_ROOT}/${PDK}/libs.ref/gf180mcu_ocd_ip_sram/spice/gf180mcu_ocd_ip_sram__sram512x8m8wm1.spice $circuit2
readnet spice ${PDK_ROOT}/${PDK}/libs.ref/gf180mcu_ocd_ip_sram/spice/gf180mcu_ocd_ip_sram__sram256x8m8wm1.spice $circuit2
readnet spice ${PDK_ROOT}/${PDK}/libs.ref/gf180mcu_ocd_ip_sram/spice/gf180mcu_ocd_ip_sram__sram64x8m8wm1.spice $circuit2
readnet spice ../ip/simple_por_3v3_regulated/netlist/schematic/por_3v3_selfbiased.spice $circuit2
readnet verilog defs.v $circuit2
readnet verilog ../verilog/ocd_mux_array.v $circuit2
readnet verilog ../verilog/constant_block.v $circuit2
readnet verilog ../verilog/gf180mcu_ocd_io__fill10x.v $circuit2
readnet verilog ../verilog/chip_half_frame.v $circuit2
readnet verilog ../verilog/gf180mcu_ocd_sram_test2.v $circuit2

set circuit1 [readnet spice ../netlist/layout/gf180mcu_ocd_sram_test2.spice]

lvs "$circuit1 gf180mcu_ocd_sram_test2" "$circuit2 gf180mcu_ocd_sram_test2" \
${PDK_ROOT}/${PDK}/libs.tech/netgen/${PDK}_setup.tcl comp.out
