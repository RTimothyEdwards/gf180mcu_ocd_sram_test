# Tcl script for setting up LVS for the gf180mcu_ocd_sram_test chip
if {[catch {set PDK_ROOT $::env(PDK_ROOT)}]} {set PDK_ROOT /usr/share/pdk} 
if {[catch {set PDK $::env(PDK)}]} {set PDK gf180mcuD}

# Read from defs.v to set the netlist format to verilog as well as
# setting global definitions needed, like USE_POWER_PINS.
set circuit2 [readnet spice ${PDK_ROOT}/${PDK}/libs.ref/gf180mcu_ocd_io/spice/gf180mcu_ocd_io.spice]
readnet spice ${PDK_ROOT}/${PDK}/libs.ref/gf180mcu_as_sc_mcu7t3v3/spice/gf180mcu_as_sc_mcu7t3v3.spice $circuit2
readnet verilog defs.v $circuit2
readnet verilog ../verilog/ocd_mux_array.v $circuit2
readnet verilog ../verilog/lvlshift_down.v $circuit2
readnet verilog ../verilog/constant_block.v $circuit2
readnet verilog ../verilog/gf180mcu_ocd_io__fill10x.v $circuit2
readnet verilog ../verilog/chip_half_frame.v $circuit2
readnet verilog ../verilog/gf180mcu_ocd_sram_test.v $circuit2

set circuit1 [readnet spice ../magic/gf180mcu_ocd_sram_test.spice]

# lvs "$circuit1 gf180mcu_ocd_sram_test" "$circuit2 gf180mcu_ocd_sram_test" \
# ${PDK_ROOT}/${PDK}/libs.tech/netgen/${PDK}_setup.tcl comp.out -noflatten=noflatten.lst

lvs "$circuit1 gf180mcu_ocd_sram_test" "$circuit2 gf180mcu_ocd_sram_test" \
${PDK_ROOT}/${PDK}/libs.tech/netgen/${PDK}_setup.tcl comp.out
